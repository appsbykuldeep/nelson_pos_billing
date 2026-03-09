import 'dart:convert';

import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

/// use this call for parse more data from large [Map]
/// This is helpfull for ignore case sensitivity from [Map] key
///
/// final parser = ParseMapValue(input: json);
class ParseMapValue {
  final dynamic input;

  ParseMapValue({required this.input}) {
    _init();
  }

  final Map<String, dynamic> _lowerKeyMap = {};

  Map<String, dynamic> get lowerKeyMap => _lowerKeyMap;

  void _init() {
    if (input is Map<String, dynamic>) {
      for (var x in (input as Map<String, dynamic>).entries) {
        _lowerKeyMap[x.key.toLowerCase().trim()] = x.value;
      }
    }
  }

  static Map<String, dynamic> toLowerkeyMap(Map<String, dynamic> json) {
    final keys = json.keys.toList();
    for (var k in keys) {
      json[k.toLowerCase()] = json[k];
    }
    return json;
  }

  T? _valueFetcherForKey<T>(String key) {
    try {
      return _lowerKeyMap[key.toLowerCase().trim()];
    } catch (e) {
      return null;
    }
  }

  T? _valueFetcherForKeys<T>({required List<String> keys}) {
    try {
      for (var key in keys) {
        final val = _lowerKeyMap[key.toLowerCase().trim()];
        if (val != null) {
          return val;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // for single key

  String getString(String key, [String placeHolder = ""]) {
    return getStringOrNull(key) ?? placeHolder;
  }

  String? getStringOrNull(String key) {
    final val = _valueFetcherForKey(key);
    return parseSringOrNull(val);
  }

  double getdouble(String key, [double placeHolder = 0]) {
    return getnumOrNull(key)?.toDouble() ?? placeHolder;
  }

  int getint(String key, [int placeHolder = 0]) {
    return getnumOrNull(key)?.toInt() ?? placeHolder;
  }

  int? getintOrNull(String key) {
    return getnumOrNull(key)?.toInt();
  }

  num getnum(String key, [num placeHolder = 0]) {
    return getnumOrNull(key) ?? placeHolder;
  }

  num? getnumOrNull(String key) {
    final val = _valueFetcherForKey(key);

    return parsenumOrNull(val);
  }

  bool getbool(String key, [bool placeHolder = false]) {
    return getboolOrNull(key) ?? placeHolder;
  }

  bool getSyncStatus(String key, [bool placeHolder = false]) {
    return getint(key) % 2 != 0;
  }

  bool? getboolOrNull(String key) {
    final val = _valueFetcherForKey(key);
    return parseBoolOrNull(val);
  }

  DateTime getDateTimeAccordingSource(String key, {required bool fromServer}) {
    if (fromServer) {
      return getDateTimeFromINDToLocal(key);
    }

    return getDateTime(key);
  }

  DateTime? getDateTimeOrNullAccordingSource(
    String key, {
    required bool fromServer,
  }) {
    if (fromServer) {
      return getDateTimeFromINDToLocalOrNull(key);
    }

    return getDateTimeOrNull(key);
  }

  DateTime getDateTimeFromINDToLocal(String key, [DateTime? placeHolder]) {
    return getDateTimeFromINDToLocalOrNull(key) ??
        placeHolder ??
        DateTime(1990);
  }

  DateTime? getDateTimeFromINDToLocalOrNull(
    String key, [
    DateTime? placeHolder,
  ]) {
    final d0 = _getDateTimeOrNull(key) ?? placeHolder;
    return d0?.fromIndianToLocal();
  }

  DateTime getDateTime(String key, [DateTime? placeHolder]) {
    return getDateTimeOrNull(key) ?? placeHolder ?? DateTime(1990);
  }

  DateTime? getDateTimeOrNull(String key, [DateTime? placeHolder]) {
    return _getDateTimeOrNull(key, placeHolder);
  }

  DateTime? _getDateTimeOrNull(String key, [DateTime? placeHolder]) {
    final val = _valueFetcherForKey(key);

    return parseDateTimeOrNull(val) ?? placeHolder;
  }

  List<dynamic> getList(String key, [List<dynamic> placeHolder = const []]) {
    return getListOrNull(key) ?? placeHolder;
  }

  List<dynamic>? getListOrNull(String key) {
    final val = _valueFetcherForKey(key);

    return parseListOrNull(val);
  }

  T getValue<T>(String key, T placeHolder) {
    final val = _valueFetcherForKey(key) ?? placeHolder;
    if (val is T) {
      return val;
    }
    return placeHolder;
  }

  dynamic getdynamic(String key, [dynamic placeHolder]) {
    return _valueFetcherForKey(key) ?? placeHolder;
  }

  // for multi keys
  String fetchString(List<String> keys, [String placeHolder = ""]) {
    return fetchStringOrNull(keys) ?? placeHolder;
  }

  String? fetchStringOrNull(List<String> keys) {
    final val = _valueFetcherForKeys(keys: keys);
    return parseSringOrNull(val);
  }

  double fetchdouble(List<String> keys, [double placeHolder = 0]) {
    return fetchnumOrNull(keys)?.toDouble() ?? placeHolder;
  }

  int fetchint(List<String> keys, [int placeHolder = 0]) {
    return fetchnumOrNull(keys)?.toInt() ?? placeHolder;
  }

  num fetchnum(List<String> keys, [num placeHolder = 0]) {
    return fetchnumOrNull(keys) ?? placeHolder;
  }

  num? fetchnumOrNull(List<String> keys) {
    final val = _valueFetcherForKeys(keys: keys);
    return parsenumOrNull(val);
  }

  bool fetchbool(List<String> keys, [bool placeHolder = false]) {
    return fetchboolOrNull(keys) ?? placeHolder;
  }

  bool? fetchboolOrNull(List<String> keys) {
    final val = _valueFetcherForKeys(keys: keys);
    return parseBoolOrNull(val);
  }

  DateTime fetchDateTimeAccordingSource(
    List<String> keys, {
    required bool fromServer,
  }) {
    if (fromServer) {
      return fetchDateTimeFromINDToLocal(keys);
    }

    return fetchDateTime(keys);
  }

  DateTime? fetchDateTimeOrNullAccordingSource(
    List<String> keys, {
    required bool fromServer,
  }) {
    if (fromServer) {
      return fetchDateTimeFromINDToLocalOrNull(keys);
    }

    return fetchDateTimeOrNull(keys);
  }

  DateTime fetchDateTimeFromINDToLocal(
    List<String> keys, [
    DateTime? placeHolder,
  ]) {
    return fetchDateTimeFromINDToLocalOrNull(keys) ??
        placeHolder ??
        DateTime(1990);
  }

  DateTime? fetchDateTimeFromINDToLocalOrNull(
    List<String> keys, [
    DateTime? placeHolder,
  ]) {
    final d0 = _fetchDateTimeOrNull(keys) ?? placeHolder;
    return d0?.fromIndianToLocal();
  }

  DateTime fetchDateTime(List<String> keys, [DateTime? placeHolder]) {
    return fetchDateTimeOrNull(keys) ?? placeHolder ?? DateTime(1990);
  }

  DateTime? fetchDateTimeOrNull(List<String> keys, [DateTime? placeHolder]) {
    return _fetchDateTimeOrNull(keys, placeHolder);
  }

  DateTime? _fetchDateTimeOrNull(List<String> keys, [DateTime? placeHolder]) {
    final val = _valueFetcherForKeys(keys: keys);
    return parseDateTimeOrNull(val) ?? placeHolder;
  }

  List<dynamic> fetchList(
    List<String> keys, [
    List<dynamic> placeHolder = const [],
  ]) {
    return fetchListOrNull(keys) ?? placeHolder;
  }

  List<dynamic>? fetchListOrNull(List<String> keys) {
    final val = _valueFetcherForKeys(keys: keys);
    return parseListOrNull(val);
  }

  dynamic fetchdynamic(List<String> keys, [dynamic placeHolder]) {
    return _valueFetcherForKeys(keys: keys) ?? placeHolder;
  }

  // static data type enusre methods

  static bool? parseBoolOrNull(dynamic val) {
    if (val is bool) {
      return val;
    }
    if (val is num) {
      return val == 1;
    }
    if (val is List<int>) {
      val = String.fromCharCodes(val);
    }
    if (val is String) {
      final val1 = val.trim();
      if (val1.isEmpty) return null;

      final x0 = bool.tryParse(val1, caseSensitive: false);
      if (x0 != null) return x0;
      final x1 = num.tryParse(val1);
      if (x1 != null) return x1 == 1;
      if (val1 == "t") return true;
      if (val1 == "f") return false;
    }
    return null;
  }

  static DateTime? parseDateTimeOrNull(dynamic val) {
    if (val is DateTime) {
      return val;
    }
    if (val is String) {
      return DateTime.tryParse(val);
    }

    return null;
  }

  static List<dynamic>? parseListOrNull(dynamic val) {
    if (val is List) {
      return val;
    }
    return null;
  }

  static num? parsenumOrNull(dynamic val) {
    if (val is num) {
      return val;
    }
    if (val is String) {
      return num.tryParse(val);
    }
    return null;
  }

  static int? parseIntOrNull(dynamic val) {
    return parsenumOrNull(val)?.toInt();
  }

  static double? parseDoubleOrNull(dynamic val) {
    return parsenumOrNull(val)?.toDouble();
  }

  static String? parseSringOrNull(dynamic val) {
    if (val == null) {
      return null;
    }
    if (val is String) {
      return val;
    } else {
      return val.toString();
    }
  }

  // static DateTime? parse(dynamic val) {
  //   return null;
  // }

  void devLog() {
    jsonEncode(_lowerKeyMap).developerLog();
  }
}
