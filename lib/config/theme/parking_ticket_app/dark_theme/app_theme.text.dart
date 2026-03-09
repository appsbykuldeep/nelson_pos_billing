part of 'app_theme.dart';

// ignore: unused_element
final TextTheme _textTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w800,
    color: _textBaseColor,
    fontSize: 57,
  ),
  displayMedium: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.bold,
    color: _textBaseColor,
    fontSize: 45,
  ),
  displaySmall: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.bold,
    color: _textBaseColor,
    fontSize: 36,
  ),
  headlineLarge: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
    fontSize: 32,
  ),
  headlineMedium: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
    fontSize: 28,
  ),
  headlineSmall: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
    fontSize: 24,
  ),
  titleLarge: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
    fontSize: 22,
  ),
  titleMedium: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
    fontSize: 16,
  ),
  titleSmall: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
    fontSize: 14,
  ),
  bodyLarge: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    color: _textBaseColor,
    fontSize: 14,
  ),
  bodyMedium: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    color: _textBaseColor,
    fontSize: 12,
  ),
  bodySmall: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    color: _textBaseColor,
    fontSize: 10,
  ),
  labelLarge: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w700,
    color: _textBaseColor,
    fontSize: 14,
  ),
  labelMedium: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.bold,
    color: _textBaseColor,
    fontSize: 12,
  ),
  labelSmall: TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.bold,
    color: _textBaseColor,
    fontSize: 10,
  ),
);

const TextTheme _textThemev2 = TextTheme(
  // Large display text for prominent titles
  displayLarge: TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    color: _mainColor,
  ),
  displayMedium: TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    color: _mainColor,
  ),
  displaySmall: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: _mainColor,
  ),

  // Headlines for sections or cards
  headlineLarge: TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  ),
  headlineMedium: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  ),
  headlineSmall: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  ),

  // Titles for app bar, sections, or list items
  titleLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
  titleMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  ),
  titleSmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  ),

  // Body text for general content
  bodyLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: _textBaseColor,
  ),
  bodyMedium: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: _textBaseColor,
  ),
  bodySmall: TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    color: _textBaseColor,
  ),

  // Labels for buttons, tabs, etc.
  labelLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: _textBaseColor, // Typically for button text
  ),
  labelMedium: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: _textBaseColor,
  ),
  labelSmall: TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: _textBaseColor,
  ),
);
