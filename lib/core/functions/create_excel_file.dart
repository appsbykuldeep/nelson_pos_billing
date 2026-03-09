import 'dart:io';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/launchers.dart';

Future<void> createExcelFile(
  List<Map<String, dynamic>> dataRows, {
  required String fileNamePrefix,
  Function()? onDone,
  // ( column index,Description)
  List<(int, String)> titleDescriptions = const [],
  // List<(int, String)> footerDescriptions = const [],
}) async {
  try {
    if (dataRows.isEmpty) {
      return;
    }
    Excel excel = Excel.createExcel();
    Sheet sh = excel['Sheet1'];
    int iRow = 0;

    final dataWidthIndex = (dataRows[0]).entries.length - 1;

    for (var desCol in titleDescriptions) {
      final startIndex = CellIndex.indexByColumnRow(
        columnIndex: desCol.$1,
        rowIndex: iRow,
      );
      final rcell = sh.cell(startIndex);
      rcell.value = _parseCellValue(desCol.$2);
      rcell.cellStyle = CellStyle(
        verticalAlign: VerticalAlign.Top,
        horizontalAlign: HorizontalAlign.Center,
        fontSize: 11,
        bold: true,
      );
      if (dataWidthIndex >= 1) {
        sh.merge(
          startIndex,
          CellIndex.indexByColumnRow(
            columnIndex: desCol.$1 + dataWidthIndex,
            rowIndex: iRow,
          ),
        );
      }

      iRow++;
    }

    Map<int, int?> colWidthMap = {};

    bool isHeadSet = false;

    for (Map<String, dynamic> row in dataRows) {
      int iCol = 0;

      if (!isHeadSet) {
        for (var one in row.entries) {
          final col = one.key;
          var hCell = sh.cell(
            CellIndex.indexByColumnRow(columnIndex: iCol, rowIndex: iRow),
          );
          hCell.cellStyle = _hedCellStyle(col, one.value);
          hCell.value = TextCellValue(col);

          colWidthMap[iCol] = [
            colWidthMap[iCol] ?? 0,
            col.length,
          ].reduce((a, b) => a > b ? a : b);

          iCol++;
        }
        iRow++;
        iCol = 0;
        isHeadSet = true;
      }

      for (var col in row.values) {
        final rcell = sh.cell(
          CellIndex.indexByColumnRow(columnIndex: iCol, rowIndex: iRow),
        );
        rcell.value = _parseCellValue(col);
        rcell.cellStyle = _dataCellStyle(iRow);

        colWidthMap[iCol] = [
          colWidthMap[iCol] ?? 0,
          col.toString().length,
        ].reduce((a, b) => a > b ? a : b);
        iCol++;
      }

      iRow++;
    }

    // Setting column width

    // for (var x in colWidthMap.entries) {
    //   final cw = (x.value ?? 0) * 1.14;
    //   sh.setColWidth(x.key, cw < 9 ? 9 : (cw + 2));
    // }

    final fName = "$fileNamePrefix ${DateTime.now().fileNameDateTime}.xlsx";
    "fName : $fName".developerLog();
    List<int>? data;
    data = excel.save(fileName: fName);
    if (kIsWeb) return;
    if (data != null) {
      String? dir;
      dir = await _getDownloadDir();

      final file = File("$dir/$fName");
      file.createSync(recursive: true);
      await file.writeAsBytes(data);

      "file : ${file.path}".developerLog();

      onDone?.call();

      final openStatus = await openFilefn(
        file.path,
        type:
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      );

      "openStatus : $openStatus".developerLog();

      if (dir.contains("0/")) {
        final folderName = dir.split("/").last;
        '"$fName" File saved in "$folderName" folder.'.showToast;
      }
    } else {
      onDone?.call();
      "Unable to generate excel.".showToast;
    }
  } catch (e) {
    onDone?.call();

    "Something is wrong.".showToast;
  }
}

Future<String> _getDownloadDir() async {
  try {
    return (await getDownloadDirectory()).path;
  } catch (e) {
    String? dir;
    dir ??= (await getDownloadsDirectory())?.path;
    dir ??= (await getApplicationDocumentsDirectory()).path;

    return dir;
  }
}

dynamic _parseCellValue(dynamic value) {
  if (value == null) {
    return TextCellValue("");
  }
  if (value is int) {
    return IntCellValue(value);
  }
  if (value is double) {
    return DoubleCellValue(value);
  }
  if (value is DateTime) {
    return DateTimeCellValue.fromDateTime(value);
  }
  if (value is bool) {
    return BoolCellValue(value);
  }
  return TextCellValue("$value");
}

CellStyle _hedCellStyle(String key, dynamic val) {
  key = key.toLowerCase();

  return CellStyle(
    verticalAlign: VerticalAlign.Top,
    horizontalAlign: (val is num)
        ? HorizontalAlign.Right
        : HorizontalAlign.Left,
    fontSize: 11,
    bold: true,
  );
}

CellStyle _dataCellStyle(int rowNum) {
  return CellStyle(
    verticalAlign: VerticalAlign.Top,
    fontSize: 11,
    backgroundColorHex: rowNum.isOdd
        ? ExcelColor.fromHexString("#b6bab7")
        : ExcelColor.none,
  );
}

// Future<List<String>> listFoldersInExternalStorage() async {

//   "Download"
//   "Documents"
//   // Path to external storage directory
//   final Directory externalDir = Directory('/storage/emulated/0/');

//   // List all entities in the directory (files and folders)
//   final List<FileSystemEntity> entities = externalDir.listSync();

//   // Filter out directories only
//   final List<String> folderNames = entities
//       .whereType<Directory>()
//       .map((dir) => dir.path.split('/').last)
//       .toList();

//   return folderNames;
// }
