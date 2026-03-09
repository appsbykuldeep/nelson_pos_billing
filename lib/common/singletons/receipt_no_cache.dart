import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class ReceiptNoCache {
  static final Map<String, int> _cache = {};
  static final List<String> _order = [];
  static const int maxSize = 100;

  static void add(String uid, int data) {
    if (_cache.containsKey(uid)) {
      _order.remove(uid);
    } else {
      if (_order.length >= maxSize) {
        final oldestKey = _order.removeAt(0);
        _cache.remove(oldestKey);
      }
    }

    _order.add(uid);
    _cache[uid] = data;
  }

  static int? get(String? uid) => _cache[uid];

  static void parseBySyncData(dynamic data) {
    if (data is List) {
      for (Map<String, dynamic> row in data) {
        final uid = row.getStringOrNull("saleUID");
        final receiptNo = row.getintOrNull("tokenNumber");

        if (uid != null && receiptNo != null) {
          add(uid, receiptNo);
        }
      }
    }
  }

  // static bool contains(String uid) => _cache.containsKey(uid);

  // static List<String> get keys => List.unmodifiable(_order);

  // static void clear() {
  //   _cache.clear();
  //   _order.clear();
  // }

  // static int get length => _cache.length;
}
