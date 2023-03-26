// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labels.dart';

// **************************************************************************
// VariantDataGenerator
// **************************************************************************

class LabelsData {
  const LabelsData(
    this._flag, {
    required this.hello,
  });

  factory LabelsData.fromVariant(Variant variant) {
    final flag = variant.hashCode;
    return LabelsData(
      variant.flag & 0x2000, // 10000000000000
      hello: () {
        // Language.fr ~ 10000000000000
        if (flag & 0x2000 == 0x2000) {
          return (() => 'Bonjour')();
        }
        return (() => 'Hello')();
      }(),
    );
  }

  final int _flag;

  final String hello;

  LabelsData update(Variant variant) {
    if (_flag != variant.flag & 0x2000) {
      return LabelsData.fromVariant(variant);
    }
    return this;
  }
}
