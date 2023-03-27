// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variants.dart';

// **************************************************************************
// VariantGenerator
// **************************************************************************

abstract class VariantFlag {
  const VariantFlag(this.value);

  final int value;

  @override
  int get hashCode => value;
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VariantFlag && other.hashCode == hashCode);
  }
}

class BrightnessFlag extends VariantFlag {
  const BrightnessFlag._(super.value);

  static const light = BrightnessFlag._(0x1 /* 1 */);

  static const dark = BrightnessFlag._(0x2 /* 10 */);
}

class AnimationFlag extends VariantFlag {
  const AnimationFlag._(super.value);

  static const all = AnimationFlag._(0x4 /* 100 */);

  static const minimal = AnimationFlag._(0x8 /* 1000 */);

  static const none = AnimationFlag._(0x10 /* 10000 */);
}

class HapticFlag extends VariantFlag {
  const HapticFlag._(super.value);

  static const all = HapticFlag._(0x20 /* 100000 */);

  static const minimal = HapticFlag._(0x40 /* 1000000 */);

  static const none = HapticFlag._(0x80 /* 10000000 */);
}

class FormFactorFlag extends VariantFlag {
  const FormFactorFlag._(super.value);

  static const mobile = FormFactorFlag._(0x100 /* 100000000 */);

  static const tablet = FormFactorFlag._(0x200 /* 1000000000 */);

  static const desktop = FormFactorFlag._(0x400 /* 10000000000 */);
}

class LanguageFlag extends VariantFlag {
  const LanguageFlag._(super.value);

  static const en = LanguageFlag._(0x800 /* 100000000000 */);

  static const de = LanguageFlag._(0x1000 /* 1000000000000 */);

  static const fr = LanguageFlag._(0x2000 /* 10000000000000 */);
}

extension BrightnessFlagExtension on Brightness {
  int get flag {
    switch (this) {
      case Brightness.light:
        return BrightnessFlag.light.value;

      case Brightness.dark:
        return BrightnessFlag.dark.value;
    }
  }
}

extension AnimationFlagExtension on Animation {
  int get flag {
    switch (this) {
      case Animation.all:
        return AnimationFlag.all.value;

      case Animation.minimal:
        return AnimationFlag.minimal.value;

      case Animation.none:
        return AnimationFlag.none.value;
    }
  }
}

extension HapticFlagExtension on Haptic {
  int get flag {
    switch (this) {
      case Haptic.all:
        return HapticFlag.all.value;

      case Haptic.minimal:
        return HapticFlag.minimal.value;

      case Haptic.none:
        return HapticFlag.none.value;
    }
  }
}

extension FormFactorFlagExtension on FormFactor {
  int get flag {
    switch (this) {
      case FormFactor.mobile:
        return FormFactorFlag.mobile.value;

      case FormFactor.tablet:
        return FormFactorFlag.tablet.value;

      case FormFactor.desktop:
        return FormFactorFlag.desktop.value;
    }
  }
}

extension LanguageFlagExtension on Language {
  int get flag {
    switch (this) {
      case Language.en:
        return LanguageFlag.en.value;

      case Language.de:
        return LanguageFlag.de.value;

      case Language.fr:
        return LanguageFlag.fr.value;
    }
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

  bool matchesEvery(Set<VariantFlag> variants) {
    final flag = variants.fold(0x0, (flag, variant) => flag & variant.value);
    return this.flag & flag == flag;
  }

  bool matchesAny(Set<VariantFlag> variants) {
    final flag = variants.fold(0x0, (flag, variant) => flag & variant.value);
    return this.flag & flag != 0;
  }

  get flag =>
      brightness.flag &
      animation.flag &
      haptic.flag &
      formFactor.flag &
      language.flag;
  @override
  int get hashCode => flag;
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Variant && other.flag == flag);
  }
}
