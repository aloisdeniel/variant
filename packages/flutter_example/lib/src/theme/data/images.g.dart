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
        // Brightness.dark, Language.fr ~ 10000000000010
        if (flag & 0x2002 == 0x2002) {
          return (() =>
              const NetworkImage('htts://myapp.com/images/fr/dark/logo.png'))();
        } // Brightness.light, Language.fr ~ 10000000000001
        if (flag & 0x2001 == 0x2001) {
          return (() => const NetworkImage(
              'htts://myapp.com/images/fr/light/logo.png'))();
        } // Brightness.dark ~ 10
        if (flag & 0x2 == 0x2) {
          return (() =>
              const NetworkImage('htts://myapp.com/images/en/dark/logo.png'))();
        }
        return (() =>
            const NetworkImage('htts://myapp.com/images/en/light/logo.png'))();
      }(),
    );
  }

  final ImageProvider logo;
}
