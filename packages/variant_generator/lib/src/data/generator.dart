import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart' as gen;
import 'package:code_builder/code_builder.dart';

import 'analyzer.dart';
import 'definitions.dart';

class VariantDataGenerator extends gen.Generator {
  @override
  String generate(gen.LibraryReader library, BuildStep buildStep) {
    final result = LibraryBuilder();

    final data = analyzeData(library);
    generateDataClasses(result, data);

    final emitter = DartEmitter();
    return '${result.build().accept(emitter)}';
  }

  void generateDataClasses(
    LibraryBuilder library,
    List<VariantsDataDefinition> data,
  ) {
    if (data.isNotEmpty) {
      for (var dataClass in data) {
        final result = ClassBuilder()..name = dataClass.name;

        // Constructor
        final constructor = ConstructorBuilder()..constant = true;

        for (var property in dataClass.properties) {
          constructor.optionalParameters.add(
            Parameter(
              (b) => b
                ..name = property.name
                ..named = true
                ..toThis = true
                ..required = true,
            ),
          );
        }
        result.constructors.add(constructor.build());

        // Factory "fromVariant"
        final fromVariantBody = StringBuffer();
        fromVariantBody.write('final flag = variant.hashCode;');
        fromVariantBody.write('return ${dataClass.name}(');

        for (var property in dataClass.properties) {
          fromVariantBody.write(property.name);
          fromVariantBody.write(': (){');

          for (var variant in property.variantFactories) {
            fromVariantBody.write(
                '// ${variant.variants.map((e) => '${e.variant}.${e.name}').join(', ')}\n');
            final combinedFlag = '0x${variant.combinedFlag.toRadixString(16)}';
            fromVariantBody
                .write('if (flag & $combinedFlag == $combinedFlag) {');
            fromVariantBody.write('return ${variant.factory};');
            fromVariantBody.write('}');
          }

          fromVariantBody.write('return ${property.fallbackFactory};');

          fromVariantBody.write('}(),');
        }
        fromVariantBody.write(');');

        final fromVariant = ConstructorBuilder()
          ..factory = true
          ..name = 'fromVariant'
          ..body = Code(fromVariantBody.toString());

        fromVariant.requiredParameters.add(
          Parameter((b) => b
            ..name = 'variant'
            ..type = refer('Variant')),
        );
        result.constructors.add(fromVariant.build());

        // Fields
        for (var property in dataClass.properties) {
          result.fields.add(
            Field(
              (b) => b
                ..name = property.name
                ..type = refer(property.type)
                ..modifier = FieldModifier.final$,
            ),
          );
        }

        library.body.add(result.build());
      }
    }
  }
}
