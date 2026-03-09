import 'package:flutter/material.dart';

enum DeviceType {
  mobileSmall(0, 320),
  mobileMedium(320, 480),
  mobileLarge(480, 600),
  tabletSmall(600, 840),
  tabletLarge(840, 1024),
  desktop(1024, 9999);

  final double minSize;
  final double maxSize;

  const DeviceType(this.minSize, this.maxSize);

  static DeviceType getBySize(Size size) {
    return getByWidth(size.width);
  }

  static DeviceType getByWidth(double width) {
    return switch (width) {
      < 320 => mobileSmall,
      < 480 => mobileMedium,
      < 600 => mobileLarge,
      < 840 => tabletSmall,
      < 1024 => tabletLarge,
      _ => desktop,
    };
  }
  // static DeviceType getByWidth(double width) {
  //   // mobile
  //   if (width <= mobileLarge.maxSize) {
  //     if (_isSizeBetween(width, mobileSmall)) {
  //       return mobileSmall;
  //     }
  //     if (_isSizeBetween(width, mobileMedium)) {
  //       return mobileMedium;
  //     }
  //     if (_isSizeBetween(width, mobileLarge)) {
  //       return mobileLarge;
  //     }
  //   }
  //   // tab
  //   if (width <= tabletLarge.maxSize) {
  //     if (_isSizeBetween(width, tabletSmall)) {
  //       return tabletSmall;
  //     }
  //     if (_isSizeBetween(width, tabletLarge)) {
  //       return tabletLarge;
  //     }
  //   }

  //   return desktop;
  // }

  // static bool _isSizeBetween(double width, DeviceType type) {
  //   return type.minSize < width && width <= type.maxSize;
  // }

  bool get isMobileSmall => this == mobileSmall;
  bool get isMobileMedium => this == mobileMedium;
  bool get isMobileLarge => this == mobileLarge;
  bool get isMobile => [mobileSmall, mobileMedium, mobileLarge].contains(this);

  bool get isTabletSmall => this == tabletSmall;
  bool get isTabletLarge => this == tabletLarge;
  bool get isTablet => [tabletSmall, tabletLarge].contains(this);

  bool get isDesktop => this == desktop;
}
