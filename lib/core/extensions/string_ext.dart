import 'dart:convert';
import 'dart:developer' as dev;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_strength/password_strength.dart';
import 'package:pos_billing/common/dialogues/show_alert.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/constants/const_regx.dart';

extension ParkStringExt on String {
  Future<void> get showAlert async {
    if (isEmpty) return;
    await AlertDialogue.show(this);
  }

  Future<void> showAlertWithContext(BuildContext? context) async {
    if (isEmpty) return;
    await AlertDialogue.show(this, context: context);
  }

  String? get nullOnEmpty => isEmpty ? null : this;

  /// Converting string to proper case....
  String toProperCase() {
    return (this)
        .replaceAll(RegExp(' +'), ' ')
        .split(" ")
        .map((str) => inCaps(str))
        .join(" ");
  }

  String inCaps(String value) => value.isNotEmpty
      ? '${value[0].toUpperCase()}${value.toLowerCase().substring(1)}'
      : '';

  /// converting string to encryted form  of string by MD5
  String get toMd5 {
    return md5.convert(utf8.encode(this)).toString();
  }

  bool get isWeekPW =>
      kDebugMode ? false : estimatePasswordStrength(this) < 0.35;

  TimeOfDay? toTimeOfDay() {
    final timeParts = split(":").map((e) => int.tryParse(e) ?? 0).toList();
    if (timeParts.length < 2) return null;

    return TimeOfDay(hour: timeParts[0], minute: timeParts[1]);
  }

  void get showToast async {
    final msj = trim();
    if (msj.isEmpty) return;

    // if (App.isDesktopDevice) {
    //   FlutterToastr.show(
    //     msj,
    //     App.context,
    //     duration: FlutterToastr.lengthShort,
    //     position: FlutterToastr.bottom,
    //   );
    //   return;
    // }

    if (kIsWeb || App.isMobileDevice) {
      Fluttertoast.showToast(
        msg: msj,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } else {
      final ct = App.context;
      final snackBar = SnackBar(
        content: Text(msj),
        dismissDirection: DismissDirection.down,
        showCloseIcon: true,
        duration: const Duration(seconds: 1),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(ct).removeCurrentSnackBar();
        ScaffoldMessenger.of(ct).showSnackBar(snackBar);
      });
    }
  }

  bool get isURL => (Uri.tryParse(this) ?? Uri()).host.isNotEmpty;
  bool get isAssetPath => toLowerCase().startsWith("assets/");

  String maxLength(int len) {
    if (length > len) {
      return substring(0, len);
    }
    return this;
  }

  Uri? parseValidUri() {
    String val = this;
    if (val.endsWith("/")) {
      val = val.substring(0, val.length - 1);
    }
    final uri = Uri.tryParse(val);

    if (uri != null && uri.host.isNotEmpty && uri.scheme.isNotEmpty) {
      return uri;
    }
    return null;
  }

  bool equalTo(String? other) => this == other;

  String onEmptyPlaceHolder(String text) => isEmpty ? text : this;

  void developerLog([String name = ""]) {
    if (!kReleaseMode) {
      final now = DateTime.now();
      dev.log("$now : $this", name: name);
    }
  }

  num toNum([num placeHolder = 0]) => num.tryParse(this) ?? placeHolder;
  double toDouble([double placeHolder = 0]) =>
      double.tryParse(this) ?? placeHolder;
  int toInt([int placeHolder = 0]) => int.tryParse(this) ?? placeHolder;

  bool get isNumber => num.tryParse(this) != null;

  String formatVehicleNumber() {
    if (1 == 1) {
      return RegExp(
        r'[A-Za-z]+|\d+',
      ).allMatches(toUpperCase()).map((m) => m.group(0)!).toList().join("-");
    }

    String input = toUpperCase();
    try {
      // BH Series pattern
      final bhRegExp = RegExp(
        r'^(?<year>\d{2})BH(?<number>\d{4})(?<letters>[A-Z]{2})$',
      );
      final bhMatch = bhRegExp.firstMatch(input);

      if (bhMatch != null) {
        final year = bhMatch.namedGroup('year') ?? '';
        final number = bhMatch.namedGroup('number') ?? '';
        final letters = bhMatch.namedGroup('letters') ?? '';

        return '$year-BH-$number-$letters';
      }

      // Regular vehicle number pattern (with optional state/district)
      final normalRegExp = RegExp(
        r'^(?:(?<state>[A-Z]{2}))?(?:(?<district>\d{1,2}))?(?<series>[A-Z]{0,3})(?<number>\d{4})$',
      );

      final match = normalRegExp.firstMatch(input);

      if (match != null) {
        final state = match.namedGroup('state') ?? '';
        final district = match.namedGroup('district') ?? '';
        final series = match.namedGroup('series') ?? '';
        final number = match.namedGroup('number') ?? '';

        return [
          state,
          district,
          series,
          number,
        ].where((e) => e.isNotEmpty).join('-');

        //     final part1 = (state + district).isNotEmpty ? "$state $district" : null;
        // final part2 = series;
        // final part3 = number;
        // return [
        //   if (part1 != null) part1,
        //   part2,
        //   part3,
        // ].join('-');
      }

      return input;
    } catch (e) {
      return input;
    }
  }

  String parseUnicodeChar() {
    final x = unicodeRegx.firstMatch(this);
    if (x != null) {
      final code = x.namedGroup('code') ?? '';
      final unicode = String.fromCharCode(int.parse("0x$code"));
      return replaceAll(unicodeRegx, unicode);
    }
    return this;
  }

  /// apply this on without country code.
  String? validateMobileNumber(int mobMinLen, int mobMaxLen) {
    final len = trim().length;

    if (mobMaxLen == mobMinLen && len != mobMinLen) {
      return "Mobile number must be $mobMinLen digits.";
    }
    if (len < mobMinLen) {
      return "Mobile number must be least $mobMinLen digits.";
    }
    if (len > mobMaxLen) {
      return "Mobile number must be less than $mobMaxLen digits.";
    }

    return null;
  }

  bool get isValidMobileNumber => mobileNumberStrictRegx.hasMatch(this);

  String whatsAppNumberOnly(String callingCode) {
    return replaceFirst(callingCode, "");
  }

  List<String> splitGetNonEmpty(Pattern pattern) {
    return split(
      pattern,
    ).where((e) => e.isNotEmpty).map((e) => e.trim()).toList();
  }

  String showvechicalCategoryName(bool forValetServeice) {
    return forValetServeice && !toLowerCase().contains("valet")
        ? "$this (Valet)"
        : this;
  }

  int get numaricCharCount => numaricCharRegx.allMatches(this).length;
  int get alphabetCharCount => alphabetCharRegx.allMatches(this).length;
  int get colonCharCount => colonCharRegx.allMatches(this).length;

  double getTextWidth(TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }

  bool get isLikeUrl => startsWith(httpOrFileRegx);

  List<Uri> parseUrisByCSV(String basePath) {
    return parseUrlsByCSV(basePath).map((e) => Uri.parse(e)).toList();
  }

  List<String> parseUrlsByCSV(String basePath) {
    List<String> local = [];
    if (isNotEmpty) {
      for (var e in split(",")) {
        if (e.trim().isEmpty) {
          continue;
        }
        if (e.startsWith(httpOrFileRegx)) {
          local.add(e);
        } else {
          if (e.startsWith("/")) {
            local.add("$basePath$e");
          } else {
            local.add("$basePath/$e");
          }
        }
      }
      // ("parseUrlsByCSV", basePath, local).toString().developerLog();
    }

    return local;
  }

  String showReceiptNo(String uuid) {
    return onNullOrEmpty(uuid.split("@").last);
  }

  bool copyToClipboard() {
    if (trim().isNotEmpty) {
      Clipboard.setData(ClipboardData(text: this));
      return true;
    }
    return false;
  }

  String formatMobileNumber() {
    if (length <= 5) return this;
    return '${substring(0, 5)}-${substring(5)}';
  }
}

extension ParkNullStringExt on String? {
  String onNullOrEmpty(String placeHolder) {
    return (this == null || this!.isEmpty) ? placeHolder : this!;
  }
}
