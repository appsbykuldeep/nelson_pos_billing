import 'dart:convert';
import 'dart:io';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_billing/common/singletons/memory_data_cache.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/launchers.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' show AnchorElement;

class PdfHelper {
  PdfHelper._();

  static final PdfHelper _instance = PdfHelper._();

  static PdfHelper get instance => _instance;

  // static pw.Font? fontRegular;
  // static pw.Font? fontBold;
  static pw.ThemeData? pdfTheme;

  bool _isInit = false;

  Future<void> init() async {
    if (_isInit) return;
    _isInit = true;

    final fontRegular = pw.Font.ttf(
      await rootBundle.load(Assets.fontsNotoSansRegular),
    );
    final fontBold = pw.Font.ttf(
      await rootBundle.load(Assets.fontsNotoSansBold),
    );
    final openSans = pw.Font.ttf(
      await rootBundle.load(Assets.fontsOpenSansRegular),
    );
    final roboto = pw.Font.ttf(
      await rootBundle.load(Assets.fontsRobotoRegular),
    );

    pdfTheme = pw.ThemeData.withFont(
      // base: fontRegular,
      bold: fontBold,
      base: roboto,
      fontFallback: [roboto, openSans, fontRegular],
    );

    "loaded pdf theme".developerLog();
  }

  static Future<Uint8List?> getpdfImageByBytes(Uint8List? pdfBytes) async {
    if (pdfBytes == null) {
      return null;
    }
    final rasters = await Printing.raster(pdfBytes, dpi: 300).toList();
    return await rasters.first.toPng();
  }

  static Future<List<Uint8List>> getpdfImagesByBytes(
    Uint8List? pdfBytes,
  ) async {
    List<Uint8List> images = [];
    if (pdfBytes == null) {
      return images;
    }
    try {
      final rasters = await Printing.raster(pdfBytes, dpi: 300).toList();

      images = await Future.wait(rasters.map((e) => e.toPng()));

      // for (var e in rasters) {
      //   images.add(await e.toPng());
      // }
      return images;
    } catch (e) {
      return [];
    }
  }

  static void downloadFileUsingAnchor(
    List<int> fileInts, {
    required String fName,
  }) {
    // List<int> fileInts = List.from(data);
    AnchorElement()
      ..href =
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
      ..setAttribute("download", fName)
      ..click();
  }

  static void saveFileInWebPlatform(
    List<int> fileInts, {
    required String fName,
  }) {
    if (!kIsWeb) return;

    // List<int> fileInts = List.from(data);
    AnchorElement()
      ..href =
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
      ..setAttribute("download", fName)
      ..click();
  }

  static Future<Uint8List> cacheAndGetPdfBytes({
    required String cacheKey,
    required pw.Widget widget,
    required PdfPageFormat pageFormat,
  }) async {
    final preData = MemoryDataCache.prinable.get(cacheKey);
    if (preData != null && !kDebugMode) {
      return preData;
    }
    final doc = pw.Document(theme: PdfHelper.pdfTheme);

    doc.addPage(
      pw.Page(
        textDirection: pw.TextDirection.ltr,
        // margin: pw.EdgeInsetsDirectional.symmetric(horizontal: 10),
        build: (context) => widget,
        pageFormat: pageFormat,
      ),
    );

    final pdfBytes = await doc.save();

    MemoryDataCache.prinable.add(cacheKey, pdfBytes);

    return pdfBytes;
  }

  static Future<bool> saveAndOpen({
    required Uint8List? pdfBytes,
    required String title,
    PdfPageFormat? pageFormat,
  }) async {
    if (pdfBytes == null) return false;
    if (kIsWeb) {
      return await Printing.layoutPdf(
        onLayout: (_) => pdfBytes,

        name: title,
        forceCustomPrintPaper: true,
        format: pageFormat ?? PdfPageFormat.a4,
      );
    }

    String? dir;
    dir ??= await _getDownloadDir();
    // dir ??= (await getDownloadsDirectory())?.path;
    // dir ??= (await getApplicationDocumentsDirectory()).path;
    final file = File(
      "$dir/${title}_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );

    file.path.developerLog();

    await file.writeAsBytes(pdfBytes);

    await openFilefn(file.path);

    return true;
  }

  static Future<String?> _getDownloadDir() async {
    try {
      return (await getDownloadDirectory()).path;
    } catch (e) {
      String? dir;
      dir ??= (await getDownloadsDirectory())?.path;
      dir ??= (await getApplicationDocumentsDirectory()).path;

      return dir;
    }
  }

  static Future<bool> previewAndPrint({
    required Uint8List? pdfBytes,
    String? title,
    PdfPageFormat? pageFormat,
  }) async {
    if (pdfBytes == null) return false;

    return await Printing.layoutPdf(
      onLayout: (_) => pdfBytes,

      name: title ?? "Print",
      forceCustomPrintPaper: true,
      format: pageFormat ?? PdfPageFormat.a4,
    );
  }

  static pw.TextStyle titleLarge({
    bool bold = false,
    double fontSize = 14,

    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    color: color ?? PdfColors.black,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  static pw.TextStyle titleMid({
    bool bold = false,
    double fontSize = 14,
    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    color: color ?? PdfColors.black,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  static pw.TextStyle titleSmall({
    bool bold = false,
    double fontSize = 12,
    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    color: color ?? PdfColors.black,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  static pw.TextStyle bodyLarge({
    bool bold = false,
    double fontSize = 12,
    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    color: color ?? PdfColors.black,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  static pw.TextStyle bodyMid({
    bool bold = false,
    double fontSize = 10,
    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  static pw.TextStyle bodySmall({
    bool bold = false,
    double fontSize = 9,
    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    color: color ?? PdfColors.black,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  static pw.TextStyle bodyNote({
    bool bold = false,
    double fontSize = 7,
    PdfColor? color,
  }) => pw.TextStyle(
    fontSize: fontSize,
    color: color ?? PdfColors.black,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
}
