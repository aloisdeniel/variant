// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colors.dart';

// **************************************************************************
// VariantDataGenerator
// **************************************************************************

class ColorsData {
  const ColorsData(
    this._flag, {
    required this.accent,
  });

  factory ColorsData.fromVariant(Variant variant) {
    final flag = variant.hashCode;
    return ColorsData(
      variant.flag & 0x2, // 10
      accent: () {
        // Brightness.dark ~ 10
        if (flag & 0x2 == 0x2) {
          return (() => const Color.fromARGB(255, 85, 26, 235))();
        }
        return (() => const Color.fromARGB(255, 85, 26, 235))();
      }(),
    );
  }

  final int _flag;

  final Color accent;

  ColorsData update(Variant variant) {
    if (_flag != variant.flag & 0x2) {
      return ColorsData.fromVariant(variant);
    }
    return this;
  }
}
