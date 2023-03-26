import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' hide Animation;
import 'variants.dart';

class AppVariant extends StatelessWidget {
  const AppVariant({
    super.key,
    required this.child,
    this.formFactor,
    this.animation,
    this.brightness,
    this.haptic,
    this.language,
  });

  final FormFactor? formFactor;
  final Animation? animation;
  final Haptic? haptic;
  final Brightness? brightness;
  final Language? language;

  final Widget child;

  static Variant of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppVariantProvider>()!
        .data;
  }

  static bool matchesAny(BuildContext context, Set<Object> variants) {
    return of(context).matchesAny(variants);
  }

  static bool matchesEvery(BuildContext context, Set<Object> variants) {
    return of(context).matchesEvery(variants);
  }

  @override
  Widget build(BuildContext context) {
    return AppVariantProvider(
      data: Variant(
        formFactor: formFactor ??
            () {
              if (Platform.isIOS || Platform.isAndroid) {
                final mediaQuery = MediaQuery.of(context);
                if (mediaQuery.size.width > 600) {
                  return FormFactor.tablet;
                }
                return FormFactor.mobile;
              }

              return FormFactor.desktop;
            }(),
        animation: animation ??
            () {
              final mediaQuery = MediaQuery.of(context);
              if (mediaQuery.disableAnimations) {
                return Animation.none;
              }

              // Android devices are low-end, most of the time
              if (Platform.isAndroid) {
                return Animation.minimal;
              }

              return Animation.all;
            }(),
        haptic: haptic ?? Haptic.all,
        language: language ??
            () {
              final locale = Localizations.localeOf(context);
              switch (locale.languageCode) {
                case 'fr':
                  return Language.fr;
                case 'de':
                  return Language.de;
                default:
                  return Language.en;
              }
            }(),
        brightness: brightness ??
            () {
              final mediaQuery = MediaQuery.of(context);
              switch (mediaQuery.platformBrightness) {
                case ui.Brightness.dark:
                  return Brightness.dark;
                case ui.Brightness.light:
                  return Brightness.light;
              }
            }(),
      ),
      child: child,
    );
  }
}

class AppVariantProvider extends InheritedWidget {
  const AppVariantProvider({
    super.key,
    required super.child,
    required this.data,
  });

  final Variant data;

  @override
  bool updateShouldNotify(covariant AppVariantProvider oldWidget) {
    return oldWidget.data != data;
  }
}
