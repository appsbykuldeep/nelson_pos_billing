import 'package:flutter/material.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/config/theme/parking_boss/light_theme/app_theme.dart';
import 'package:pos_billing/config/theme/parking_ticket_app/dark_theme/app_theme.dart';
import 'package:pos_billing/config/theme/parking_ticket_app/light_theme/app_theme.dart';

enum AppCompany {
  parkingTicket(
    companyID: 1,
    title: "POS Billing",
    domain: "parkingticket.in",

    svglogoPath: "",
    pnglogoPath: Assets.imagesCounterToken,
    whatsappNumber: "919616205455",
    defcode: "vPark#",
    bundleId: "com.ganpatitechnologies.countertoken",
    showMembershipPlans: true,
    showShareApp: true,
    showChangeTheme: true,
    allowParkingPasses: true,
    allowValetParking: true,
    canCreateCustomCategory: true,
    showNeedHelp: true,
    allowNFCCard: true,
    autoSyncToCloud: true,
    allowWhatsAppSend: true,
    hostForReceiptQR: "parkingticket.in",
    whatsappNoForSmartParking: "919452094430",
  ),
  parkingBoss(
    companyID: 2,
    title: "Parking Boss",

    // domain: "parkingboss.in",
    domain: "parkingticket.in",

    svglogoPath: "",
    pnglogoPath: Assets.imagesCounterToken,
    whatsappNumber: "919633441888",
    defcode: "vPark#",
    bundleId: "com.ganpatitechnologies.parkingticket",
    showMembershipPlans: false,
    showShareApp: false,
    showChangeTheme: false,
    allowParkingPasses: true,
    allowValetParking: true,
    canCreateCustomCategory: true,
    showNeedHelp: true,
    allowNFCCard: true,
    autoSyncToCloud: true,
    allowWhatsAppSend: true,
    hostForReceiptQR: "parkingticket.in",
    whatsappNoForSmartParking: "919452094430",
  );

  final int companyID;
  final String title;
  final String domain;
  final String svglogoPath;
  final String pnglogoPath;
  final String defcode;
  final String whatsappNumber;
  final String bundleId;
  final String? hostForReceiptQR;
  final String? whatsappNoForSmartParking;

  final bool showMembershipPlans;
  final bool showShareApp;
  final bool showChangeTheme;
  final bool allowParkingPasses;
  final bool allowValetParking;
  final bool canCreateCustomCategory;
  final bool showNeedHelp;
  final bool allowNFCCard;
  final bool autoSyncToCloud;
  final bool allowWhatsAppSend;

  // String get domain => "$sld.$tld";

  bool get isParkingTicket => this == parkingTicket;
  bool get isParkingBoss => this == parkingBoss;

  ThemeData? get lightTheme => switch (this) {
    parkingBoss => parkingBossAppLightTheme,
    parkingTicket => parkingTicketAppLightTheme,
    // ignore: unreachable_switch_case
    _ => null,
  };
  ThemeData? get darkTheme => switch (this) {
    parkingTicket => parkingTicketAppDarkTheme,
    _ => null,
  };

  static AppCompany getbyValue(dynamic value) {
    if ([parkingBoss.bundleId, parkingBoss.title].contains(value)) {
      return parkingBoss;
    }

    return parkingTicket;
  }
  // static AppCompany getbyValue(dynamic value) => switch (value) {

  //   "com.ganpatitechnologies.parkingticket" => parkingTicket,
  //   "com.parkingboss.parkingticket" => parkingBoss,
  //   2 => parkingBoss,
  //   _ => parkingTicket,
  // };

  const AppCompany({
    required this.companyID,
    required this.title,
    required this.domain,
    required this.defcode,
    // required this.sld,
    // required this.tld,
    required this.svglogoPath,
    required this.pnglogoPath,
    required this.whatsappNumber,
    required this.bundleId,
    required this.showMembershipPlans,
    required this.showShareApp,
    required this.showChangeTheme,
    required this.allowParkingPasses,
    required this.allowValetParking,
    required this.canCreateCustomCategory,
    required this.showNeedHelp,
    required this.allowNFCCard,
    required this.autoSyncToCloud,
    required this.allowWhatsAppSend,
    required this.hostForReceiptQR,
    required this.whatsappNoForSmartParking,
  });
}
