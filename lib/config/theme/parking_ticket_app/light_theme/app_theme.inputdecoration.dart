part of 'app_theme.dart';

final _inputDecorationTheme = InputDecorationTheme(
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      width: _inputBorderWidth,
      color: _inputBorderColor,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      width: _inputBorderWidth,
      color: Colors.red,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      width: _inputBorderWidth,
      color: _inputBorderColor,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      width: _inputBorderWidth + 0.25,
      color: _inputBorderColor,
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      width: _inputBorderWidth,
      color: Colors.grey.shade600,
    ),
  ),
  hintStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    fontFamily: _family,
    color: Colors.grey.shade600,
  ),
);
