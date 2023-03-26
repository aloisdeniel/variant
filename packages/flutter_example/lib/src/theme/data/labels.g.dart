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
        //
        if (flag & 0x0 == 0x0) {
          return (() => 'Bonjour')();
        }
        return (() => 'Hello')();
      }(),
    );
  }

  final String hello;
}
