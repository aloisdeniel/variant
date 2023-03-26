library variant_generator.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:variant_generator/src/variant/generator.dart';

import 'src/data/generator.dart';

Builder variantBuilder(BuilderOptions options) => SharedPartBuilder(
      [VariantGenerator()],
      'variant',
    );

Builder variantDataBuilder(BuilderOptions options) => SharedPartBuilder(
      [VariantDataGenerator()],
      'variant_data',
    );
