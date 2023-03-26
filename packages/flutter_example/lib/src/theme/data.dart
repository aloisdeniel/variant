import 'package:flutter_example/src/variants/app_variant.dart';
import 'package:flutter_example/src/variants/variants.dart';

import 'data/colors.dart';
import 'data/images.dart';
import 'data/labels.dart';

class AppThemeData {
  AppThemeData({
    required this.colors,
    required this.images,
    required this.labels,
    required this.variant,
  });

  AppThemeData.fromVariant(this.variant)
      : colors = ColorsData.fromVariant(variant),
        images = ImagesData.fromVariant(variant),
        labels = LabelsData.fromVariant(variant);

  final Variant variant;
  final ColorsData colors;
  final ImagesData images;
  final LabelsData labels;

  /// Optimized update.
  AppThemeData update(Variant variant) {
    return AppThemeData(
      variant: variant,
      colors: colors.update(variant),
      images: images.update(variant),
      labels: labels.update(variant),
    );
  }

  @override
  int get hashCode => variant.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppThemeData && other.variant == variant);
  }
}
