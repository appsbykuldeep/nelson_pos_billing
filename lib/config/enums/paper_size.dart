import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:pdf/pdf.dart' as pdf;

enum AppPaperSize {
  ticket58mm(1, 250, "58"),
  ticket80mm(2, 250, "80"),
  a4(3, -1, "A4");

  final int id;
  final double widgetWidth;
  final String lable;

  const AppPaperSize(this.id, this.widgetWidth, this.lable);

  bool get is58mm => this == ticket58mm;
  bool get is80mm => this == ticket80mm;
  bool get isA4 => this == a4;

  pdf.PdfPageFormat toPdfPageFormat() => switch (this) {
    // ticket58mm => pdf.PdfPageFormat.roll57,
    ticket80mm => pdf.PdfPageFormat.roll80,
    a4 => pdf.PdfPageFormat.a4,
    _ => pdf.PdfPageFormat.roll57,
  };
  PaperSize toPOSSize() => switch (this) {
    ticket80mm => PaperSize.mm80,

    _ => PaperSize.mm58,
  };

  static List<AppPaperSize> forThurmalPrint = [ticket58mm, ticket80mm];

  factory AppPaperSize.parse(dynamic id) => switch (id) {
    1 => ticket58mm,
    2 => ticket80mm,
    58 => ticket58mm,
    80 => ticket80mm,
    "58" => ticket58mm,
    "80" => ticket80mm,
    3 => a4,
    _ => ticket58mm,
  };
}
