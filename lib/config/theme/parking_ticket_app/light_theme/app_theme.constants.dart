part of 'app_theme.dart';

const Color _mainColor = Color(0xFF2563EB);
const Color _secondaryColor = Color(0xFF14B8A6);
const Color _inputBorderColor = Color.fromARGB(255, 92, 20, 105);
const Color _scaffoldColor = Color(0xFFF5F7FA);
Color accent = Color(0xFF1E40AF);
Color surface = Colors.white;
Color success = Color(0xFF22C55E);
Color warning = Color(0xFFFACC15);
Color error = Color(0xFFEF4444);

Gradient primaryGradient = LinearGradient(
  colors: [_mainColor, _secondaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// const String _family = "NotoSans";
final String _family = AppFontFamily.poppins.lable;
const double _inputBorderWidth = 0.65;

const _textBaseColor = Colors.black;
