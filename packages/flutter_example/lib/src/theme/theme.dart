import 'package:flutter/widgets.dart';
import 'package:flutter_example/src/theme/data.dart';
import 'package:flutter_example/src/variants/app_variant.dart';

class AppTheme extends StatefulWidget {
  const AppTheme({
    super.key,
    required this.child,
    this.data,
  });

  final AppThemeData? data;
  final Widget child;

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  AppThemeData? _data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final variant = AppVariant.of(context);
    final data = _data;
    // We only update theme data if variant changed
    if (data == null) {
      _data = AppThemeData.fromVariant(variant);
    } else if (data.variant != variant) {
      _data = data.update(variant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      data: widget.data ?? _data!,
      child: widget.child,
    );
  }
}

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({
    super.key,
    required super.child,
    required this.data,
  });

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeProvider>()!.data;
  }

  @override
  bool updateShouldNotify(covariant AppThemeProvider oldWidget) {
    return oldWidget.data != data;
  }
}
