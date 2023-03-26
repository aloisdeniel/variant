import 'package:build/build.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart' as gen;
import 'package:code_builder/code_builder.dart';

import 'analyzer.dart';
import 'definitions.dart';

class VariantGenerator extends gen.Generator {
  @override
  String generate(gen.LibraryReader library, BuildStep buildStep) {
    final result = LibraryBuilder();

    final variants = analyzeVariants(library);
    generateVariantFlagExtensions(result, variants);
    generateObjectFlagExtensions(result, variants);
    generateVariantClass(result, variants);

    final emitter = DartEmitter();
    return '${result.build().accept(emitter)}';
  }

  void generateObjectFlagExtensions(
    LibraryBuilder library,
    List<VariantDefinition> variants,
  ) {
    if (variants.isNotEmpty) {
      final extension = ExtensionBuilder()
        ..name = 'ObjectFlag'
        ..on = refer('Object');

      final flag = MethodBuilder()
        ..name = 'flag'
        ..returns = refer('int')
        ..type = MethodType.getter;

      final body = StringBuffer();
      body.writeln('final value = this;');
      for (var variant in variants) {
        body.writeln('if (value is ${variant.name}) return value.flag;');
      }
      body.writeln('throw Exception(\'\$value is not a Variant\');');

      flag.body = Code(body.toString());

      extension.methods.add(flag.build());

      library.body.add(extension.build());
    }
  }

  void generateVariantFlagExtensions(
    LibraryBuilder library,
    List<VariantDefinition> variants,
  ) {
    for (var variant in variants) {
      final extension = ExtensionBuilder()
        ..name = '${variant.name}Flag'
        ..on = refer(variant.name);

      final flag = MethodBuilder()
        ..name = 'flag'
        ..returns = refer('int')
        ..type = MethodType.getter;

      final body = StringBuffer();
      body.writeln('switch(this){');
      for (var value in variant.values) {
        body.writeln('case ${variant.name}.${value.name}:');
        body.writeln('return 0x${value.flag.toRadixString(16)};');
      }
      body.writeln('}');

      flag.body = Code(body.toString());

      extension.methods.add(flag.build());

      library.body.add(extension.build());
    }
  }

  void generateVariantClass(
    LibraryBuilder library,
    List<VariantDefinition> variants,
  ) {
    if (variants.isNotEmpty) {
      final result = ClassBuilder()..name = 'Variant';

      // Constructor
      final constructor = ConstructorBuilder()..constant = true;

      for (var variant in variants) {
        constructor.optionalParameters.add(
          Parameter(
            (b) => b
              ..name = ReCase(variant.name).camelCase
              ..named = true
              ..toThis = true
              ..required = true,
          ),
        );
      }
      result.constructors.add(constructor.build());

      // Fields
      for (var variant in variants) {
        result.fields.add(
          Field(
            (b) => b
              ..name = ReCase(variant.name).camelCase
              ..type = refer(variant.name)
              ..modifier = FieldModifier.final$,
          ),
        );
      }

      // MatchesEvery

      final matchesEveryBody = StringBuffer();
      matchesEveryBody.write(
        'final flag = variants.fold(0x0, (flag, variant) => flag & variant.flag);',
      );
      matchesEveryBody.write(
        'return this.flag & flag == flag;',
      );
      final matchesEvery = MethodBuilder()
        ..name = 'matchesEvery'
        ..returns = refer('bool')
        ..body = Code(matchesEveryBody.toString());

      matchesEvery.requiredParameters.add(
        Parameter(
          (b) => b
            ..name = 'variants'
            ..type = refer('Set<Object>'),
        ),
      );

      result.methods.add(matchesEvery.build());

      // MatchesAny

      final matchesAnyBody = StringBuffer();
      matchesAnyBody.write(
        'final flag = variants.fold(0x0, (flag, variant) => flag & variant.flag);',
      );
      matchesAnyBody.write(
        'return this.flag & flag != 0;',
      );
      final matchesAny = MethodBuilder()
        ..name = 'matchesAny'
        ..returns = refer('bool')
        ..body = Code(matchesAnyBody.toString());

      matchesAny.requiredParameters.add(
        Parameter(
          (b) => b
            ..name = 'variants'
            ..type = refer('Set<Object>'),
        ),
      );

      result.methods.add(matchesAny.build());

      // Equality

      //  - Hashcode
      final hashCodeBody = variants
          .map((variant) => ReCase(variant.name).camelCase)
          .map((name) => '$name.flag')
          .join(' & ');

      final hashCode = MethodBuilder()
        ..annotations.add(const CodeExpression(Code("override")))
        ..name = 'hashCode'
        ..returns = refer('int')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(hashCodeBody);

      result.methods.add(hashCode.build());

      //  - Operator ==
      final operatorEqualEqualBody = 'return '
          'identical(this, other) || '
          '(other is Variant && other.hashCode == hashCode)'
          ';';

      final operatorEqualEqual = MethodBuilder()
        ..annotations.add(const CodeExpression(Code("override")))
        ..name = 'operator =='
        ..returns = refer('bool')
        ..body = Code(operatorEqualEqualBody);

      operatorEqualEqual.requiredParameters.add(
        Parameter(
          (b) => b
            ..name = 'other'
            ..type = refer('Object'),
        ),
      );

      result.methods.add(operatorEqualEqual.build());

      library.body.add(result.build());
    }
  }
}
