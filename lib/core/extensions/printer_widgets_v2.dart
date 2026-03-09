// import 'package:unified_esc_pos_printer/unified_esc_pos_printer.dart';

// //```dart ```

// extension KdPrinterExt on String {
//   List<int> ptText(Generator gt, {PrintTextStyle? styles}) {
//     if (isEmpty) {
//       return [];
//     }
//     return gt.text(this, styles: styles ?? const PrintTextStyle());
//   }

//   /// ```dart
//   /// PosStyles get prtStyle2 => const PosStyles(
//   ///       align: PosAlign.center,
//   ///       bold: true,
//   ///       height: PosTextSize.size2,
//   ///       width: PosTextSize.size2,
//   ///     );
//   /// ```

//   List<int> ptSiteName(Generator gt) => ptText(
//     gt,
//     styles: const PosStyles(
//       align: PosAlign.center,
//       bold: true,
//       height: PosTextSize.size2,
//       width: PosTextSize.size1,
//     ),
//   );

//   List<int> ptTokenTime(Generator gt) => ptText(
//     gt,
//     styles: const PosStyles(
//       align: PosAlign.center,
//       bold: true,
//       height: PosTextSize.size1,
//       width: PosTextSize.size2,
//     ),
//   );

//   List<int> ptTokenCount(Generator gt) => ptText(
//     gt,
//     styles: const PosStyles(
//       align: PosAlign.center,
//       bold: true,
//       height: PosTextSize.size3,
//       width: PosTextSize.size2,
//     ),
//   );

//   List<int> ptLargeBold(Generator gt) => ptText(gt, styles: prtStyle2);
//   List<int> ptLargeBold2(Generator gt) => ptText(gt, styles: prtStyle7);
//   List<int> ptMidBold(Generator gt) => ptText(gt, styles: prtStyle3);
//   List<int> ptMidBoldLeft(Generator gt) => ptText(gt, styles: prtStyle9);
//   List<int> ptMidBold2(Generator gt) => ptText(gt, styles: prtStyle6);
//   List<int> ptCnterBold(Generator gt) => ptText(gt, styles: prtStyle3);
//   List<int> ptCnterBold2(Generator gt) => ptText(gt, styles: prtStyle8);
//   List<int> ptCenter(Generator gt) => ptText(gt, styles: prtStyle4);
//   List<int> ptLeft(Generator gt) => ptText(gt, styles: prtStyle10);
//   List<int> ptNormalSmallCenter(Generator gt) => ptText(gt, styles: prtStyle11);
//   // List<int> ptLargeBold(Generator gt) => gt.text(this, styles: prtStyle2);
//   // List<int> ptLargeBold2(Generator gt) => gt.text(this, styles: prtStyle7);
//   // List<int> ptMidBold(Generator gt) => gt.text(this, styles: prtStyle3);
//   // List<int> ptMidBoldLeft(Generator gt) => gt.text(this, styles: prtStyle9);
//   // List<int> ptMidBold2(Generator gt) => gt.text(this, styles: prtStyle6);
//   // List<int> ptCnterBold(Generator gt) => gt.text(this, styles: prtStyle3);
//   // List<int> ptCnterBold2(Generator gt) => gt.text(this, styles: prtStyle8);
//   // List<int> ptCenter(Generator gt) => gt.text(this, styles: prtStyle4);
//   // List<int> ptLeft(Generator gt) => gt.text(this, styles: prtStyle10);
//   // List<int> ptNormalSmallCenter(Generator gt) =>
//   //     gt.text(this, styles: prtStyle11);
// }

// PosStyles get prtStyle1 => const PosStyles(align: PosAlign.center, bold: true);
// PosStyles get prtStyle2 => const PosStyles(
//   align: PosAlign.center,
//   bold: true,
//   height: PosTextSize.size2,
//   width: PosTextSize.size2,
// );
// PosStyles get prtStyle3 => const PosStyles(
//   align: PosAlign.center,
//   bold: true,
//   height: PosTextSize.size1,
//   width: PosTextSize.size1,
// );
// PosStyles get prtStyle4 => const PosStyles(align: PosAlign.center);

// PosStyles get prtStyle5 => const PosStyles(align: PosAlign.center, bold: true);
// PosStyles get prtStyle6 => const PosStyles(
//   align: PosAlign.center,
//   bold: true,
//   height: PosTextSize.size1,
//   width: PosTextSize.size2,
// );
// PosStyles get prtStyle7 => const PosStyles(
//   align: PosAlign.center,
//   bold: true,
//   height: PosTextSize.size2,
//   width: PosTextSize.size3,
// );
// PosStyles get prtStyle8 => const PosStyles(
//   align: PosAlign.center,
//   bold: true,
//   height: PosTextSize.size2,
//   width: PosTextSize.size1,
// );

// PosStyles get prtStyle9 => const PosStyles(
//   align: PosAlign.left,
//   bold: true,
//   height: PosTextSize.size1,
//   width: PosTextSize.size1,
// );
// PosStyles get prtStyle10 => const PosStyles(align: PosAlign.left);

// PosStyles get prtStyle11 => const PosStyles(
//   align: PosAlign.center,
//   bold: false,
//   height: PosTextSize.size1,
//   width: PosTextSize.size1,
// );
// PosStyles get prtStyle12 => const PosStyles(
//   align: PosAlign.center,
//   height: PosTextSize.size2,
//   width: PosTextSize.size2,
// );
// PosStyles get prtStyle13 => const PosStyles(
//   align: PosAlign.center,
//   height: PosTextSize.size2,
//   width: PosTextSize.size1,
// );
