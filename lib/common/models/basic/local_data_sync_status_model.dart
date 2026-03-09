class LocalDataSyncStatus {
  bool syncstatus;
  bool syncBySoket;
  String message;
  List<Map<String, dynamic>> updateData;
  LocalDataSyncStatus({
    this.syncstatus = false,
    this.syncBySoket = false,
    this.message = '',
    this.updateData = const [],
  });
}
