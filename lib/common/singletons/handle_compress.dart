import 'dart:convert';

import 'package:archive/archive.dart';

class HandleCompress {
  HandleCompress._();

  static dynamic decodeZLibAndGetJson(List<int> bytes) {
    try {
      final decompressedData = const ZLibDecoder().decodeBytes(bytes);

      return jsonDecode(utf8.decode(decompressedData));
    } catch (e) {
      return null;
    }
  }
}
