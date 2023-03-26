// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// VariantDataGenerator
// **************************************************************************

class ImagesData {
  const ImagesData(
    this._flag, {
    required this.logo,
  });

  factory ImagesData.fromVariant(Variant variant) {
    final flag = variant.hashCode;
    return ImagesData(
      variant.flag & 0x2003, // 10000000000011
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

  final int _flag;

  final ImageProvider logo;

  ImagesData update(Variant variant) {
    if (_flag != variant.flag & 0x2003) {
      return ImagesData.fromVariant(variant);
    }
    return this;
  }
}
