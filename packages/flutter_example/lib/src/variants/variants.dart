import 'package:variant/variant.dart';

part 'variants.g.dart';

@variant
enum Brightness {
  light,
  dark,
}

@variant
enum Animation {
  all,
  minimal,
  none,
}

@variant
enum Haptic {
  all,
  minimal,
  none,
}

@variant
enum FormFactor {
  mobile,
  tablet,
  desktop,
}

@variant
enum Language {
  en,
  de,
  fr,
}
