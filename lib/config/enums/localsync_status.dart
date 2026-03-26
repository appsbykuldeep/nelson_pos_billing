import 'package:flutter/material.dart';

enum LocalDataSyncState {
  checking(Icons.sync, null),
  updated(Icons.cloud_done, Colors.green),
  pending(Icons.cloud_upload, Colors.red),
  uploading(Icons.cloud_sync, Colors.red);

  final IconData iconData;
  final Color? color;

  const LocalDataSyncState(this.iconData, this.color);

  bool get ischecking => this == checking;
  bool get isupdated => this == updated;
  bool get ispending => this == pending;
  bool get isuploading => this == uploading;
}
