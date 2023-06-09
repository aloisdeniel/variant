import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';
import 'package:variant/variant.dart';
import 'package:variant_generator/src/utils.dart';
import 'package:variant_generator/src/variant/analyzer.dart';
import 'package:variant_generator/src/variant/definitions.dart';

import 'definitions.dart';

List<VariantsDataDefinition> analyzeData(
  LibraryReader library,
) {
  final dataClasses = library
      .annotatedWith(TypeChecker.fromRuntime(VariantData))
      .map((element) => element.element)
      .whereType<ClassElement>()
      .toList();

  final variantDefinitions = loadVariants(library);

  final result = <VariantsDataDefinition>[];
  for (var dataClass in dataClasses) {
    final properties = <VariantsDataPropertyDefinition>[];

    final fields =
        dataClass.fields.where((field) => field.getter != null).toList();

    for (var field in fields) {
      final getter = field.getter as PropertyAccessorElement;

      final ast = getter.findAstNode();
      if (ast != null) {
        final property =
            analyzeDataProperty(field.name, ast, variantDefinitions);
        if (property != null) properties.add(property);
      }
    }

    result.add(
      VariantsDataDefinition(
        name: ReCase('${dataClass.name}_Data').pascalCase,
        properties: properties,
      ),
    );
  }

  return result;
}

List<VariantDefinition> loadVariants(LibraryReader library) {
  final result = <VariantDefinition>[];
  for (var importedLibrary in library.element.importedLibraries) {
    result.addAll(analyzeVariants(LibraryReader(importedLibrary)));
  }

  return result;

  //library.element.session.getResolvedLibrary(path)
  //final variantLibrary = library.findType(name)?.library;
  //return analyzeVariants(LibraryReader(variantLibrary!));
}

VariantsDataPropertyDefinition? analyzeDataProperty(
  String name,
  AstNode node,
  List<VariantDefinition> variantDefinitions,
) {
  final body = node.childEntities.whereType<ExpressionFunctionBody>().first;
  final instance = body.expression;
  if (instance is MethodInvocation) {
    final propertyTypeName = instance.typeArguments?.arguments.first.toString();

    final fallbackFactory =
        generateFactoryInvocation(instance.argumentList.arguments.first);
    final variantFactoryArgs = instance.argumentList.arguments.last;

    final variantFactories = <VariantsDataPropertyVariantFactoryDefinition>[];
    if (variantFactoryArgs is SetOrMapLiteral) {
      for (var element in variantFactoryArgs.elements) {
        if (element is MapLiteralEntry) {
          final variantKeys = element.key;
          if (variantKeys is SetOrMapLiteral) {
            final factory = generateFactoryInvocation(element.value);
            final variants = <VariantValueDefinition>[];

            for (var variantKey in variantKeys.elements) {
              if (variantKey is PrefixedIdentifier) {
                final value = variantDefinitions
                    .expand((element) => element.values)
                    .firstWhere((element) =>
                        element.variant == variantKey.prefix.name &&
                        element.name == variantKey.identifier.name);

                variants.add(value);
              }
            }

            variantFactories.add(
              VariantsDataPropertyVariantFactoryDefinition(
                factory: factory,
                variants: variants,
              ),
            );
          }
        }
      }
    }

    // We prioritize the variants with most combination first
    variantFactories
        .sort((a, b) => b.variants.length.compareTo(a.variants.length));

    return VariantsDataPropertyDefinition(
      name: name,
      type: propertyTypeName!,
      fallbackFactory: fallbackFactory,
      variantFactories: variantFactories,
    );
  }

  return null;
}

String generateFactoryInvocation(Expression expression) {
  return '(${expression.toString()})()';
}
