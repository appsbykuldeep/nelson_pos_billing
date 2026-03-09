import 'package:flutter/material.dart';

enum AppGeneralOption {
  none("", "", Icons.circle),

  print("Print", "", Icons.print),
  paymentQR("Payment QR", "", Icons.qr_code),
  valetView("Valet View", "", Icons.hail_outlined),
  view("View", "", Icons.visibility),
  search("Search", "", Icons.search),
  refresh("Refresh", "", Icons.refresh),
  downloadAsExcel("Excel", "", Icons.download),
  download("Download", "", Icons.download),

  disconnect("Disconnect", "", Icons.power_off),
  reIssue("Re-Issue", "", Icons.refresh),
  earnings("Earnings", "", Icons.currency_rupee),
  history("History", "", Icons.history),
  // availableToAll("Cloud", "", Icons.lan),
  cloudDone("Cloud", "", Icons.cloud_done),
  hide("Hide", "", Icons.visibility_off),
  edit("Edit", "", Icons.edit),
  delete("Delete", "", Icons.delete),

  totorialVideo("Tutorial", "", Icons.video_collection);

  bool get isNone => this == none;
  bool get isprint => this == print;

  bool get isview => this == view;
  bool get ispaymentQR => this == paymentQR;
  bool get isvaletView => this == valetView;
  bool get issearch => this == search;
  bool get isrefresh => this == refresh;
  bool get isdownloadAsExcel => this == downloadAsExcel;
  bool get isdisconnect => this == disconnect;
  bool get iscloudDone => this == cloudDone;
  bool get isReIssue => this == reIssue;
  bool get isearnings => this == earnings;
  bool get ishistory => this == history;
  bool get ishide => this == hide;
  bool get isedit => this == edit;
  bool get isdelete => this == delete;
  bool get isdownload => this == download;
  bool get istotorialVideo => this == totorialVideo;

  final String label;
  final String svgPath;
  final IconData iconData;

  const AppGeneralOption(this.label, this.svgPath, this.iconData);
}
