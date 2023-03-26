library variant;

const variant = VariantFlag();

class VariantFlag {
  const VariantFlag();
}

const variantData = VariantData();

class VariantData {
  const VariantData();
}

typedef VariantsFactory<T> = T Function();

class Variants<T> {
  const Variants(
    VariantsFactory<T> fallback, [
    Map<Set, VariantsFactory<T>>? variants,
  ]);
}
