// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// VariantDataGenerator
// **************************************************************************

class ImagesData {
  const ImagesData({required this.logo});

  factory ImagesData.fromVariant(Variant variant) {
    final flag = variant.hashCode;
    return ImagesData(
      logo: () {
        //
        if (flag & 0x0 == 0x0) {
          return (() =>
              const NetworkImage('htts://myapp.com/images/en/dark/logo.png'))();
        } //
        if (flag & 0x0 == 0x0) {
          return (() =>
              const NetworkImage('htts://myapp.com/images/fr/dark/logo.png'))();
        } //
        if (flag & 0x0 == 0x0) {
          return (() => const NetworkImage(
              'htts://myapp.com/images/fr/light/logo.png'))();
        }
        return (() =>
            const NetworkImage('htts://myapp.com/images/en/light/logo.png'))();
      }(),
    );
  }

  final ImageProvider logo;
}
