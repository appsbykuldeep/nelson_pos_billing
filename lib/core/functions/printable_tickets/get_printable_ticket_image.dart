import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:pos_billing/common/singletons/printer_ctrl.dart';

Future<List<int>> getPrintableTicketImageByImage({
  required Generator ticket,
  required Uint8List? imageBase64,
}) async {
  if (imageBase64 == null) {
    return [];
  }

  List<int> bytes = [];

  img.Image? logoImage;

  logoImage = img.decodeImage(imageBase64);

  if (logoImage != null) {
    // logoImage = img.grayscale(logoImage);

    // logoImage = img.adjustColor(logoImage, contrast: 1.2);

    final paperSize = BlueThurmalPrint.instance.selectedpaperSize;
    logoImage = img.copyResize(
      logoImage,
      width: paperSize.width,
      interpolation: img.Interpolation.average,
    );
  } else {
    throw Exception("Invalid image format");
  }

  // bytes += ticket.reset();

  bytes += ticket.imageRaster(logoImage);

  bytes += ticket.cut(afterLines: 2);

  return bytes;
}
