import 'package:pos_billing/common/classes/parse_map_value.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/data_source/local_source/local_db.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/basic/local_data_sync_status_model.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/singletons/receipt_no_cache.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/config/enums/master_data_enum.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class SyncLocalData {
  SyncLocalData._();

  static final SyncLocalData _instance = SyncLocalData._();

  static SyncLocalData get instance => _instance;

  final _login = LoginUtil.instance;
  final _db = LocalDb.instance;

  static final List<String> masterTables = [
    "ParkedVehicalMaster",
    "ParkedVechialPaymentMaster",
    "ParkingPassHistoryMaster",
    "ParkedPassVehicleMaster",
    "PointTransactionMaster",
    "InstantReceiptMaster",
  ];

  static final List<String> statusColumns = [
    "isSyncedToServer",
    "syncedOnServer",
  ];

  static Future<List<Map<String, dynamic>>> _fetchUnSyncedDta(
    sqflite.Database db,
    String tableName, {
    String instanceUID = "",
  }) async {
    try {
      //(t.isSyncedToServer %2) = 0 or isSyncedToServer in (0,2,4) indicate that data is not synced

      String query =
          "select t.*,  '$instanceUID' as InstanceUID from $tableName as t where (t.isSyncedToServer %2) = 0 and isOfflineBilling <> 1;";

      final data = await db.rawQuery(query);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<(bool, String, Set<MasterDataType>)> _getAndSyncUnSyncedData(
    List<sqflite.Database> dbFiles, {
    required int timeoutSec,
  }) async {
    bool uploadStatus = false;
    String message = "No data found !";
    Set<MasterDataType> dataChangeIn = {};
    // final dbFiles = [..._olddatabases, currentDb];
    for (var db in dbFiles) {
      Map<String, dynamic> unSyncedData = {};
      // Setting instance Id

      unSyncedData["siteId"] = _login.siteId;
      unSyncedData["userId"] = _login.userId;

      try {
        int datacount = 0;
        for (var tableName in masterTables) {
          final rows = await _fetchUnSyncedDta(db, tableName);
          if (rows.isEmpty) {
            continue;
          }

          datacount += rows.length;
          if (unSyncedData[tableName] is List<dynamic>) {
            rows.addAll(unSyncedData[tableName]);
          }

          unSyncedData[tableName] = rows;

          final mtype = MasterDataType.parseByTableName(tableName);
          if (rows.isNotEmpty && mtype != null) {
            dataChangeIn.add(mtype);
          }
        }
        if (datacount > 0) {
          (uploadStatus, message) = await _uploadUpdateData(
            db,
            unSyncedData,
            timeoutSec: timeoutSec,
          );
        }
      } catch (e) {
        continue;
      }
    }

    return (
      uploadStatus,
      message,
      uploadStatus ? dataChangeIn : <MasterDataType>{},
    );
  }

  static Future<(bool, String)> _uploadUpdateData(
    sqflite.Database db,
    Map<String, dynamic> unSyncedData, {
    required int timeoutSec,
  }) async {
    final resp = await uploadUnSyncedData(unSyncedData, timeoutSec: timeoutSec);
    await updateSyncStatus(db, resp.updateData);
    return (resp.syncstatus, resp.message);
  }

  static Future<bool> updateSyncStatus(
    sqflite.Database db,
    List<Map<String, dynamic>> responseData,
  ) async {
    try {
      if (responseData.isEmpty) return true;

      final batch = db.batch();
      for (var row in responseData) {
        final parser = ParseMapValue(input: row);
        final tableName = parser.getString("tableName");
        final isSyncedToServer = parser.getint("isSyncedToServer");
        final syncedOnSerer = parser
            .getDateTimeAccordingSource("syncedOnSerer", fromServer: true)
            .toString();

        final pColName = parser.getString("UIDColName");
        final pColID = parser.getString("UID");
        final irReceiptNo = parser.getStringOrNull("irReceiptNo");
        final pvReceiptNo = parser.getStringOrNull("pvReceiptNo");
        final ppReceiptNo = parser.getStringOrNull("ppReceiptNo");
        final ptReceiptNo = parser.getStringOrNull("ptReceiptNo");

        batch.update(
          tableName,
          {
            'isSyncedToServer': isSyncedToServer,
            'syncedOnSerer': syncedOnSerer,
            "irReceiptNo": ?irReceiptNo,
            "pvReceiptNo": ?pvReceiptNo,
            "ppReceiptNo": ?ppReceiptNo,
            "ptReceiptNo": ?ptReceiptNo,
          },
          where: '$pColName = ?',
          whereArgs: [pColID],
          conflictAlgorithm: sqflite.ConflictAlgorithm.fail,
        );
      }

      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      "updateSyncStatus : $e".developerLog();
      return false;
    }
  }

  static Future<LocalDataSyncStatus> uploadUnSyncedData(
    Map<String, dynamic> unSyncedData, {
    required int timeoutSec,
  }) async {
    LocalDataSyncStatus syncStatus = LocalDataSyncStatus();
    final currentSoket = SocketIoHandler.currentSocket;
    if (currentSoket == null) {
      return syncStatus;
    }

    final resp = await currentSoket.emitWithResponse(
      SoketEvents.syncLocalDBV5,
      unSyncedData,
      timeOutSec: 120,
      progessStatus: LoadingDialogue.setProgressStatus,
    );

    List<Map<String, dynamic>> updateData = [];

    if (resp.resultData is Map) {
      final data = resp.resultData['data'] ?? resp.resultData['localDBResult'];
      if (data is List<dynamic>) {
        updateData = List<Map<String, dynamic>>.from(data);
      }
    } else if (resp.resultData is List<dynamic>) {
      updateData = List<Map<String, dynamic>>.from(resp.resultData);
    }
    syncStatus.syncstatus = resp.resultStatus;
    syncStatus.syncBySoket = true;
    syncStatus.message = resp.resultMessage;
    syncStatus.updateData = updateData;

    ReceiptNoCache.parseBySyncData(updateData);

    return syncStatus;
  }
}
