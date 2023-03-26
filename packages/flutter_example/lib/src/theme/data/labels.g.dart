// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labels.dart';

// **************************************************************************
// VariantDataGenerator
// **************************************************************************

class LabelsData {
  const LabelsData({required this.hello});

  factory LabelsData.fromVariant(Variant variant) {
    final flag = variant.hashCode;
    return LabelsData(
      hello: () {
        // Language.fr ~ 10000000000000
        if (flag & 0x2000 == 0x2000) {
          return (() => 'Bonjour')();
        }
        return (() => 'Hello')();
      }(),
    );
  }

  final String hello;
}
