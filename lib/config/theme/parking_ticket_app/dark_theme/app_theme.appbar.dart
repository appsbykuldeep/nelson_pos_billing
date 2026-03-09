part of 'app_theme.dart';

final AppBarTheme _appBarTheme = AppBarTheme(
  titleSpacing: 5,
  centerTitle: false,
  // toolbarHeight: Constans.kAppbarHeight,
  iconTheme: const IconThemeData(color: _mainColor),
  titleTextStyle: TextStyle(
    color: _mainColor,
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ),
  toolbarTextStyle: TextStyle(
    color: _mainColor,
    fontFamily: _family,
    fontWeight: FontWeight.normal,
    fontSize: 11,
  ),
  actionsIconTheme: const IconThemeData(color: _mainColor),
  elevation: 5,
  color: _scaffoldColor,
);
