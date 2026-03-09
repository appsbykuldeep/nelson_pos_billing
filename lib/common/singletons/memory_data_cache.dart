import 'dart:typed_data';

class MemoryDataCache {
  final int maxSize;
  final Map<String, Uint8List> _cache = {};
  final List<String> _order = [];

  MemoryDataCache({this.maxSize = 5});

  static final MemoryDataCache prinable = MemoryDataCache();

  void add(String uid, Uint8List data) {
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

  Uint8List? get(String uid) => _cache[uid];

  bool contains(String uid) => _cache.containsKey(uid);

  List<String> get keys => List.unmodifiable(_order);

  void clear() {
    _cache.clear();
    _order.clear();
  }

  int get length => _cache.length;
}
