import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> gtOpenUrlfn(String url) async {
  return await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future<bool> openFilefn(
  String url, {
  String? type,

  bool useLauncher = false,
}) async {
  try {
    if (kIsWeb || Platform.isWindows || useLauncher) {
      return await launchUrl(
        Uri.file(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      OpenFilex.open(url, type: type);
    }
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> gtDialNumberfn(String mobile) async {
  mobile = mobile.replaceAll(" ", "");
  if (!mobile.isValidMobileNumber) return false;
  return await launchUrl(
    Uri.parse("tel:$mobile"),
    mode: LaunchMode.externalApplication,
  );
}

Future<bool> gtSendMailWithSub(String mailid, {String subject = ""}) async {
  mailid = mailid.replaceAll(" ", "");
  if (!(mailid.contains("@") && mailid.contains("."))) return false;
  String url = "mailto:$mailid?subject=$subject";
  return await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future<bool> openMapWithDestinationPath({
  required double latitude,
  required double longitude,
}) async {
  String url =
      "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving";
  return await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
