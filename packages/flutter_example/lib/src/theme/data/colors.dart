import 'package:flutter/widgets.dart';
import 'package:flutter_example/src/variants/variants.dart';
import 'package:variant/variant.dart';

part 'colors.g.dart';

@variantData
abstract class Colors {
  get accent => Variants<Color>(
        () => const Color.fromARGB(255, 85, 26, 235),
        {
          {Brightness.dark}: () => const Color.fromARGB(255, 85, 26, 235),
        },
      );
}
