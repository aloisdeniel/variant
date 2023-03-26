// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colors.dart';

// **************************************************************************
// VariantDataGenerator
// **************************************************************************

class ColorsData {
  const ColorsData({required this.accent});

  factory ColorsData.fromVariant(Variant variant) {
    final flag = variant.hashCode;
    return ColorsData(
      accent: () {
        // Brightness.dark ~ 10
        if (flag & 0x2 == 0x2) {
          return (() => const Color.fromARGB(255, 85, 26, 235))();
        }
        return (() => const Color.fromARGB(255, 85, 26, 235))();
      }(),
    );
  }

  final Color accent;
}
