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
    generateVariantFlags(result, variants);
    generateVariantFlagExtensions(result, variants);
    generateVariantClass(result, variants);

    final emitter = DartEmitter();
    return '${result.build().accept(emitter)}';
  }

  void generateVariantFlagExtensions(
    LibraryBuilder library,
    List<VariantDefinition> variants,
  ) {
    for (var variant in variants) {
      final extension = ExtensionBuilder()
        ..name = '${variant.name}FlagExtension'
        ..on = refer(variant.name);

      final flag = MethodBuilder()
        ..name = 'flag'
        ..returns = refer('int')
        ..type = MethodType.getter;

      final body = StringBuffer();
      body.writeln('switch(this){');
      for (var value in variant.values) {
        body.writeln('case ${variant.name}.${value.name}:');
        body.writeln('return ${variant.name}Flag.${value.name}.value; \n');
      }
      body.writeln('}');

      flag.body = Code(body.toString());

      extension.methods.add(flag.build());

      library.body.add(extension.build());
    }
  }

  void generateVariantFlags(
    LibraryBuilder library,
    List<VariantDefinition> variants,
  ) {
    if (variants.isNotEmpty) {
      // Base class
      final result = ClassBuilder()
        ..abstract = true
        ..name = 'VariantFlag';

      // Constructor
      final constructor = ConstructorBuilder()..constant = true;

      constructor.requiredParameters.add(
        Parameter(
          (b) => b
            ..name = 'value'
            ..toThis = true,
        ),
      );

      result.constructors.add(constructor.build());

      // Fields

      result.fields.add(
        Field(
          (b) => b
            ..name = 'value'
            ..type = refer('int')
            ..modifier = FieldModifier.final$,
        ),
      );

      // Equality

      //  - Hashcode
      final hashCode = MethodBuilder()
        ..annotations.add(const CodeExpression(Code("override")))
        ..name = 'hashCode'
        ..returns = refer('int')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code('value');

      result.methods.add(hashCode.build());

      //  - Operator ==
      final operatorEqualEqualBody = 'return '
          'identical(this, other) || '
          '(other is VariantFlag && other.hashCode == hashCode)'
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

      // Variant implementations

      for (var variant in variants) {
        final result = ClassBuilder()
          ..extend = refer('VariantFlag')
          ..name = '${variant.name}Flag';

        // Constructor
        final constructor = ConstructorBuilder()
          ..name = '_'
          ..constant = true;

        constructor.requiredParameters.add(
          Parameter(
            (b) => b
              ..name = 'value'
              ..toSuper = true,
          ),
        );

        for (var value in variant.values) {
          final flag = '0x${value.flag.toRadixString(16)}';
          result.fields.add(
            Field(
              (b) => b
                ..name = value.name
                ..modifier = FieldModifier.constant
                ..static = true
                ..assignment = Code(
                    '${variant.name}Flag._($flag /* ${value.flag.toRadixString(2)} */)'),
            ),
          );
        }

        result.constructors.add(constructor.build());
        library.body.add(result.build());
      }
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
        'final flag = variants.fold(0x0, (flag, variant) => flag & variant.value);',
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
            ..type = refer('Set<VariantFlag>'),
        ),
      );

      result.methods.add(matchesEvery.build());

      // MatchesAny

      final matchesAnyBody = StringBuffer();
      matchesAnyBody.write(
        'final flag = variants.fold(0x0, (flag, variant) => flag & variant.value);',
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
            ..type = refer('Set<VariantFlag>'),
        ),
      );

      result.methods.add(matchesAny.build());

      // Flag

      final flagBody = variants
          .map((variant) => ReCase(variant.name).camelCase)
          .map((name) => '$name.flag')
          .join(' & ');

      final flag = MethodBuilder()
        ..name = 'flag'
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(flagBody.toString());

      result.methods.add(flag.build());

      // Equality

      //  - Hashcode

      final hashCode = MethodBuilder()
        ..annotations.add(const CodeExpression(Code("override")))
        ..name = 'hashCode'
        ..returns = refer('int')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code('flag');

      result.methods.add(hashCode.build());

      //  - Operator ==
      final operatorEqualEqualBody = 'return '
          'identical(this, other) || '
          '(other is Variant && other.flag == flag)'
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
