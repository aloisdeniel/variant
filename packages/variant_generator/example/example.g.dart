part of 'example.dart';

// GENERATED : DO NOT MODIFY BY HAND

extension ObjectFlag on Object {
  int get flag {
    final value = this;
    if (value is Brightness) return value.flag;
    if (value is Language) return value.flag;
    return 0x0;
  }
}

extension BrightnessFlag on Brightness {
  int get flag {
    switch (this) {
      case Brightness.light:
        return 0x0;
      case Brightness.dark:
        return 0x1;
    }
  }
}

extension LanguageFlag on Language {
  int get flag {
    switch (this) {
      case Language.en:
        return 0x0;
      case Language.fr:
        return 0x2;
      case Language.de:
        return 0x3;
    }
  }
}

class Variant {
  Variant({
    this.brightness = Brightness.light,
    this.language = Language.en,
  });

  final Brightness brightness;
  final Language language;

  late int flag = brightness.flag & language.flag;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Variant && other.flag == flag);

  bool matchesEvery(Set<Object> variants) {
    final flag = variants.fold(0x0, (flag, variant) => flag & variant.flag);
    return this.flag & flag == flag;
  }

  bool matchesAny(Set<Object> variants) {
    final flag = variants.fold(0x0, (flag, variant) => flag & variant.flag);
    return this.flag & flag != 0;
  }

  @override
  int get hashCode => flag;
}

class LabelsData {
  const LabelsData(
    this.flag, {
    required this.hello,
  });

  factory LabelsData.fromVariant(Variant data) {
    final flag = data.flag;
    return LabelsData(
      variant.flag & 0x67774,
      hello: () {
        // {Language.fr, Brightness.dark}
        if (flag ^ 0x3344 == 0) {
          return 'Bonjour';
        }

        return 'Hello';
      }(),
    );
  }

  LabelsData update(Variant variant) {
    if (flag != variant.flag) {
      return LabelsData.fromVariant(variant);
    }

    return this;
  }

  final int flag;
  final String hello;
}
