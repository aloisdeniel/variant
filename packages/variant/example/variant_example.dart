import 'package:variant/variant.dart';

@variant
enum Brightness {
  light,
  dark,
}

@variant
enum Language {
  en,
  de,
  fr,
}

@variantData
abstract class Labels {
  get hello => Variants<String>(
        () => 'Hello',
        {
          {Language.fr}: () => 'Bonjour',
        },
      );
}
