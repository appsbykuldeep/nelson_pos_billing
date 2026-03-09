import 'package:pos_billing/core/extensions/datetime_ext.dart';

extension MapStingToGenericExt<V> on Map<String, V> {
  Map<String, V> toLowerKeys() {
    Map<String, V> out = {};
    for (var e in entries) {
      out[e.key.toLowerCase()] = e.value;
    }

    return out;
  }

  Map<String, V> toUpperKeys() {
    Map<String, V> out = {};
    for (var e in entries) {
      out[e.key.toUpperCase()] = e.value;
    }

    return out;
  }
}

// All extension method have case sensitive key
extension GetValueFromMapExt<K, V> on Map<K, V> {
  String? getStringOrNull(K key) {
    final val = this[key];

    if (val == null) {
      return null;
    }
    if (val is String) {
      return val;
    } else {
      return val.toString();
    }
  }

  String? fetchStringOrNull(List<K> keys) {
    for (var key in keys) {
      final val = getStringOrNull(key);
      if (val != null) {
        return val;
      }
    }

    return null;
  }

  String fetchString(List<K> keys, [String placeHolder = ""]) {
    return fetchStringOrNull(keys) ?? placeHolder;
  }

  String getString(K key, [String placeHolder = ""]) {
    return getStringOrNull(key) ?? placeHolder;
  }

  num? getNumOrNull(K key) {
    final val = this[key];

    if (val is num) {
      return val;
    }
    if (val is String) {
      return num.tryParse(val)?.toDouble();
    }
    return null;
  }

  num getNum(K key, [num placeHolder = 0]) {
    return getNumOrNull(key) ?? placeHolder;
  }

  double getdouble(K key, [double placeHolder = 0]) {
    return getNumOrNull(key)?.toDouble() ?? placeHolder;
  }

  double? getdoubleOrNull(K key) {
    return getNumOrNull(key)?.toDouble();
  }

  int getint(K key, [int placeHolder = 0]) {
    return getNumOrNull(key)?.toInt() ?? placeHolder;
  }

  int? getintOrNull(K key) {
    return getNumOrNull(key)?.toInt();
  }

  bool? getboolOrNull(K key) {
    final val = this[key];

    if (val is bool) {
      return val;
    }
    if (val is num) {
      return val == 1;
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

  bool getbool(K key, [bool placeHolder = false]) {
    return getboolOrNull(key) ?? placeHolder;
  }

  DateTime? getDateTimeOrNull(K key) {
    final val = this[key];

    if (val is String) {
      return DateTime.tryParse(val);
    }
    return null;
  }

  DateTime getDateTime(K key, [DateTime? placeHolder]) {
    return getDateTimeOrNull(key) ?? placeHolder ?? DateTime(1990);
  }

  Map<T1, T2>? getMapOrNull<T1, T2>(K key) {
    final val = this[key];

    if (val is Map<T1, T2>) {
      return val;
    }

    if (val is Map) {
      try {
        return Map<T1, T2>.from(val);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  Map<T1, T2> getMap<T1, T2>(K key, [Map<T1, T2>? placeHolder]) {
    return getMapOrNull(key) ?? placeHolder ?? <T1, T2>{};
  }

  List<T1>? getListOrNull<T1>(K key) {
    final val = this[key];

    if (val is List<T1>) {
      return val;
    }
    if (val is List) {
      try {
        return List<T1>.from(val);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  List<T1> getList<T1>(K key, [List<T1> placeHolder = const []]) {
    return getListOrNull(key) ?? placeHolder;
  }

  V? getValueOrNull(K key, [V? placeHolder]) {
    return this[key];
  }

  V getValue(K key, [V? placeHolder]) {
    final val = this[key];
    if (val == null) {
      if (placeHolder != null) {
        return placeHolder;
      }
      if (V is String) return "" as V;
      if (V is int) return 0 as V;
      if (V is double) return 0 as V;
      if (V is num) return 0 as V;
      if (V is bool) return false as V;
      if (V is Map) return {} as V;
      if (V is List) return [] as V;
    }
    return val!;
  }

  DateTime? getDateTimeOrNullAccordingSource(
    K key, {
    required bool fromServer,
  }) {
    if (fromServer) {
      return getDateTimeFromINDToLocalOrNull(key);
    }

    return getDateTimeOrNull(key);
  }

  DateTime? getDateTimeFromINDToLocalOrNull(K key, [DateTime? placeHolder]) {
    final d0 = getDateTimeOrNull(key) ?? placeHolder;
    return d0?.fromIndianToLocal();
  }
}
