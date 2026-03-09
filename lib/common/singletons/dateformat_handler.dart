import 'package:intl/intl.dart';

class DateformatHandler {
  DateformatHandler._();

  static final Map<String, DateFormat> _formaterCache = {};

  static DateFormat _getFormater(String format) {
    DateFormat? formater = _formaterCache[format];
    if (formater != null) {
      return formater;
    }
    formater = DateFormat(format, "en_US");
    _formaterCache[format] = formater;
    return formater;
  }

  static String formatDateTime(DateTime dateTime, String format) {
    return _getFormater(format).format(dateTime);
  }
}
