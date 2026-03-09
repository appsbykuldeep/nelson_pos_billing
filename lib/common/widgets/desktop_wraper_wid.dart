import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/enums/device_type_enum.dart';
import 'package:pos_billing/core/extensions/app_context_ext.dart';

class DesktopBodyWraperWid extends StatelessWidget {
  final Widget child;
  final double height;
  const DesktopBodyWraperWid({
    super.key,
    required this.child,
    this.height = double.maxFinite,
  });

  static const double maxWidth = 700;

  static double getWidth(BuildContext context) {
    if (isNotActive) {
      return context.sizeOf.width;
    }
    return maxWidth;
  }

  static DeviceType getDeviceType(BuildContext context) {
    if (isNotActive) {
      return DeviceType.getByWidth(context.sizeOf.width);
    }
    return DeviceType.getByWidth(maxWidth);
  }

  static Color? get backgroundColor => isNotActive ? null : Colors.grey;

  static bool get isNotActive => App.isMobileDevice;

  @override
  Widget build(BuildContext context) {
    if (isNotActive) {
      return child;
    }

    final theme = Theme.of(context);
    final surfaceColor = theme.scaffoldBackgroundColor;
    return Align(
      alignment: Alignment.topCenter,

      child: Container(
        color: surfaceColor,
        width: maxWidth,
        height: height,
        child: child,
      ),
    );
  }
}
