import 'package:flutter/material.dart';

final formattedNumberserieas = RegExp(
  r'[A-Z]{2} [0-9]{2} [A-HJ-NP-Z]{1,2} [0-9]{4}|[0-9]{2} BH[0-9]{4} [A-HJ-NP-Z]{1,2}',
);

const appPlayStoreUrl =
    "https://play.google.com/store/apps/details?id=com.ganpatitechnologies.parkingticket";

const suggestedPrinter =
    "https://www.google.com/search?q=bluetooth+thermal+printer";

const suggestedMobilePOS = "https://www.google.com/search?q=mobile+pos+machine";

const String youTubePlayList =
    "https://youtube.com/playlist?list=PLzVoa2mrLnkQymYebp9kVgMgFLsKxG3an&si=KSYJuGT7WHY9tN2w";

const Duration diffIndiaUTC = Duration(hours: 5, minutes: 30);

const String tickUniCode = "\u2713";
const String crossUniCode = "\u2717";
const String handLikeEmoji = "👍";
const String handLeftEmoji = "👉";
// final String pointUniCode = String.fromCharCode(int.parse("0x1FA99"));

const filledButtonlinearGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
);
