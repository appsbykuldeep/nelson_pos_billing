class LocalSync {
  /// Even number : 0,2,4,6 or (isSyncedToServer % 2) = 0 repreasents data is not synced with server
  ///
  /// Odd Number : 1,3,5,7 or (isSyncedToServer % 2) <> 0 represents data is synced/updated with server
  int isSyncedToServer;
  DateTime? syncedOnSerer;

  LocalSync({required this.isSyncedToServer, required this.syncedOnSerer});
}
