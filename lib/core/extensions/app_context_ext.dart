import 'package:flutter/material.dart';
import 'package:pos_billing/config/enums/device_type_enum.dart';

extension AppBuildContextExt on BuildContext {
  ThemeData get _theme => Theme.of(this);

  Color get surface => _theme.colorScheme.surface;
  Color get onSurface => _theme.colorScheme.onSurface;

  ColorFilter get primaryColorFiler =>
      ColorFilter.mode(_theme.primaryColor, BlendMode.srcIn);

  // Object? get arguments => ModalRoute.of(this)!.settings.arguments;

  bool get isDarkModeActive {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  Size get sizeOf => MediaQuery.sizeOf(this);

  DeviceType get deviceType => DeviceType.getBySize(sizeOf);
  EdgeInsets get viewPaddingOf => MediaQuery.viewPaddingOf(this);

  Color get primaryColor => _theme.primaryColor;

  RouteSettings? get routeSettings => ModalRoute.of(this)?.settings;

  T arguments<T>() => ModalRoute.of(this)?.settings.arguments as T;
  String? get routeName => ModalRoute.of(this)?.settings.name;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
}
