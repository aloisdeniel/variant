import 'package:variant/variant.dart';

part 'example.g.dart';

void main() {
  var data = Variant();
  var labels = LabelsData.fromVariant(data);
  print(labels.hello);

  data = Variant(
    brightness: Brightness.dark,
    language: Language.fr,
  );
  labels = LabelsData.fromVariant(data);
  print(labels.hello);
  print(data.matchesAny({Brightness.dark}));
}

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
          {Language.fr, Brightness.dark}: () => 'Bonjour',
        },
      );
}
