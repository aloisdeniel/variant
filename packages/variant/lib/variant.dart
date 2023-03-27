library variant;

const variant = VariantComponent();

class VariantComponent {
  const VariantComponent();
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
