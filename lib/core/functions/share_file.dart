import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

Future<void> shareFileByPath(String? filePath) async {
  if (filePath == null) {
    return;
  }

  await Share.shareXFiles([XFile(filePath)]);
}

Future<void> shareMessage(String? message) async {
  if (message == null) {
    return;
  }

  await Share.share(message);
}

Future<void> shareImageData(Uint8List? bytes, String name) async {
  if (bytes == null) {
    return;
  }

  await Share.shareXFiles([
    XFile.fromData(
      bytes,
      name: name,
      mimeType: "image/png",

      length: bytes.length,
      lastModified: DateTime.now(),
    ),
  ]);
}
