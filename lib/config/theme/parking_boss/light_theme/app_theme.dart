import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/enums/app_fontfamily.dart';

part 'app_theme.appbar.dart';
part 'app_theme.bottomsheet.dart';
part 'app_theme.button.dart';
part 'app_theme.constants.dart';
part 'app_theme.inputdecoration.dart';
part 'app_theme.listtile.dart';
part 'app_theme.text.dart';

ThemeData parkingBossAppLightTheme = ThemeData(
  primaryColor: _mainColor,

  // primaryColorLight: _mainColor1,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _mainColor,
    brightness: Brightness.light,
    secondary: _secondaryColor,
    contrastLevel: 1,
  ),

  fontFamily: _family,
  scaffoldBackgroundColor: _scaffoldColor,
  useMaterial3: true,
  textTheme: _textThemev2,
  bottomSheetTheme: _bottomSheetTheme,
  listTileTheme: _listTileTheme,
  inputDecorationTheme: _inputDecorationTheme,
  textButtonTheme: _textButtonTheme,
  filledButtonTheme: _filledButtonTheme,
  appBarTheme: _appBarTheme,
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: _mainColor,
    circularTrackColor: _mainColor.withOpacity(0.4),
    linearTrackColor: _mainColor.withOpacity(0.4),
  ),
  sliderTheme: const SliderThemeData(trackHeight: 2),
  cardTheme: const CardThemeData(
    // color: Constans.kWhite,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _mainColor,
    extendedTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  ),

  // visualDensity: VisualDensity.adaptivePlatformDensity,
  visualDensity: App.isMobileDevice
      ? null
      : const VisualDensity(horizontal: -3, vertical: -3),
  hoverColor: App.isMobileDevice
      ? Colors.transparent
      : Colors.blue.withOpacity(0.05),
  focusColor: Colors.blue.withOpacity(0.15),
  highlightColor: Colors.blue.withOpacity(0.2),
  splashColor: App.isMobileDevice
      ? Colors.transparent
      : Colors.blue.withOpacity(0.1),
);
