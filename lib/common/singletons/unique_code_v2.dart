import 'package:uuid/uuid.dart';

class UniqueCodeV2 {
  UniqueCodeV2._();

  static const _uuid = Uuid();

  static String uuid() => _uuid.v4();

  static String receiptUUID() {
    final code = _uuid.v4().replaceAll('-', '');
    final len = code.length;
    if (len > 5) {
      final index = len - 5;
      return '${code.substring(0, index)}@${code.substring(index)}';
    }
    return code;
  }
}
