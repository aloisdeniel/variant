import 'package:flutter_example/src/variants/variants.dart';
import 'package:variant/variant.dart';

part 'labels.g.dart';

@variantData
abstract class Labels {
  get hello => Variants<String>(
        () => 'Hello',
        {
          {Language.fr}: () => 'Bonjour',
        },
      );
}
