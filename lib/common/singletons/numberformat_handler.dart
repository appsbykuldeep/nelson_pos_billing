import 'package:intl/intl.dart';

class NumberformatHandler {
  NumberformatHandler._();

  static final Map<String, NumberFormat> _formaterCache = {};

  static NumberFormat _getFormater(String format) {
    NumberFormat? formater = _formaterCache[format];
    if (formater != null) {
      return formater;
    }
    formater = NumberFormat(format, "en_US");
    _formaterCache[format] = formater;
    return formater;
  }

  static String format(num value, String format) {
    return _getFormater(format).format(value);
  }
}
