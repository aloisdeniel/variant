import 'package:variant_generator/src/variant/definitions.dart';

class VariantsDataDefinition {
  const VariantsDataDefinition({
    required this.name,
    required this.properties,
  });
  final String name;
  final List<VariantsDataPropertyDefinition> properties;

  Set<VariantValueDefinition> get dependsOnVariants {
    return properties
        .map((e) => e.dependsOnVariants)
        .expand((element) => element)
        .toSet();
  }

  int get dependencyFlag {
    var result = 0x0;
    for (var variant in dependsOnVariants) {
      result |= variant.flag;
    }
    return result;
  }
}

class VariantsDataPropertyDefinition {
  const VariantsDataPropertyDefinition({
    required this.name,
    required this.type,
    required this.fallbackFactory,
    required this.variantFactories,
  });
  final String name;
  final String type;
  final String fallbackFactory;
  final List<VariantsDataPropertyVariantFactoryDefinition> variantFactories;

  Set<VariantValueDefinition> get dependsOnVariants {
    return variantFactories
        .map((e) => e.variants)
        .expand((element) => element)
        .toSet();
  }
}

class VariantsDataPropertyVariantFactoryDefinition {
  const VariantsDataPropertyVariantFactoryDefinition({
    required this.variants,
    required this.factory,
  });
  final List<VariantValueDefinition> variants;
  final String factory;

  int get combinedFlag {
    var result = 0x0;
    for (var variant in variants) {
      result |= variant.flag;
    }
    return result;
  }
}
