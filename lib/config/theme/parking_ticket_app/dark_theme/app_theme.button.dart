part of 'app_theme.dart';

final _textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    padding: const EdgeInsets.all(8),
  ),
);
final _filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: _mainColor,
    elevation: 5,
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: _whiteColor,
    ),
  ),
);

// ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
//   style: ElevatedButton.styleFrom(
//     backgroundColor: kGreen,
//     textStyle: const TextStyle(
//       color: kWhite,
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     ),
//   ),
// );
