// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variants.dart';

// **************************************************************************
// VariantGenerator
// **************************************************************************

extension BrightnessFlag on Brightness {
  int get flag {
    switch (this) {
      case Brightness.light:
        return 0x2;
      case Brightness.dark:
        return 0x4;
    }
  }
}

extension AnimationFlag on Animation {
  int get flag {
    switch (this) {
      case Animation.all:
        return 0x8;
      case Animation.minimal:
        return 0x10;
      case Animation.none:
        return 0x20;
    }
  }
}

extension HapticFlag on Haptic {
  int get flag {
    switch (this) {
      case Haptic.all:
        return 0x40;
      case Haptic.minimal:
        return 0x80;
      case Haptic.none:
        return 0x100;
    }
  }
}

extension FormFactorFlag on FormFactor {
  int get flag {
    switch (this) {
      case FormFactor.mobile:
        return 0x200;
      case FormFactor.tablet:
        return 0x400;
      case FormFactor.desktop:
        return 0x800;
    }
  }
}

extension LanguageFlag on Language {
  int get flag {
    switch (this) {
      case Language.en:
        return 0x1000;
      case Language.de:
        return 0x2000;
      case Language.fr:
        return 0x4000;
    }
  }
}

extension ObjectFlag on Object {
  int get flag {
    final value = this;
    if (value is Brightness) return value.flag;
    if (value is Animation) return value.flag;
    if (value is Haptic) return value.flag;
    if (value is FormFactor) return value.flag;
    if (value is Language) return value.flag;
    throw Exception('$value is not a Variant');
  }
}

class Variant {
  const Variant({
    required this.brightness,
    required this.animation,
    required this.haptic,
    required this.formFactor,
    required this.language,
  });

  final Brightness brightness;

  final Animation animation;

  final Haptic haptic;

  final FormFactor formFactor;

  final Language language;

  bool matchesEvery(Set<Object> variants) {
    final flag = variants.fold(0x0, (flag, variant) => flag & variant.flag);
    return this.flag & flag == flag;
  }

  bool matchesAny(Set<Object> variants) {
    final flag = variants.fold(0x0, (flag, variant) => flag & variant.flag);
    return this.flag & flag != 0;
  }

  @override
  int get hashCode =>
      brightness.flag &
      animation.flag &
      haptic.flag &
      formFactor.flag &
      language.flag;
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Variant && other.hashCode == hashCode);
  }
}
