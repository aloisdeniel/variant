import 'package:flutter/widgets.dart';
import 'package:flutter_example/src/variants/variants.dart';
import 'package:variant/variant.dart';

part 'images.g.dart';

@variantData
abstract class Images {
  get logo => Variants<ImageProvider>(
        () => const NetworkImage(
          'htts://myapp.com/images/en/light/logo.png',
        ),
        {
          {Brightness.dark}: () => const NetworkImage(
                'htts://myapp.com/images/en/dark/logo.png',
              ),
          {Brightness.dark, Language.fr}: () => const NetworkImage(
                'htts://myapp.com/images/fr/dark/logo.png',
              ),
          {Brightness.light, Language.fr}: () => const NetworkImage(
                'htts://myapp.com/images/fr/light/logo.png',
              ),
        },
      );
}
