import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:pos_billing/common/classes/time_laps.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';

final _pngDecodeer = img.PngDecoder();

Future<List<int>> getPrintableTicketImageByImage({
  required Generator ticket,
  Uint8List? imageBase64,
  img.Image? baseimage,
}) async {
  if (imageBase64 == null && baseimage == null) {
    return [];
  }

  TimeLaps t0 = TimeLaps(tag: "lap_imgconvert");

  List<int> bytes = [];

  img.Image? logoImage;

  if (imageBase64 != null) {
    // logoImage = img.PngDecoder().decodeImage(imageBase64);
    logoImage = img.decodeImage(imageBase64);
  }

  if (baseimage != null) {
    logoImage = baseimage;
  }

  t0.laps("decode");

  if (logoImage != null && imageBase64 != null) {
    // logoImage = img.grayscale(logoImage);

    // logoImage = img.adjustColor(logoImage, contrast: 1.2);

    final paperSize = BlueThurmalPrint.instance.selectedpaperSize;
    img.copyResize(
      logoImage,
      width: paperSize.width,
      // interpolation: img.Interpolation.average,
    );
    t0.laps("ressie");
  }

  // bytes += ticket.reset();

  if (logoImage != null) {
    bytes += ticket.image(logoImage);
  }

  t0.laps("raster");

  bytes += ticket.cut(afterLines: 0);

  t0.laps("cut");

  return bytes;
}
