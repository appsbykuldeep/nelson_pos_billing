import 'dart:async';
import 'dart:developer' as dev;

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_billing/common/abstract_classes/initialized_class.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/enums/master_data_enum.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqflite.dart';

part 'local_db.apphelper.dart';
part 'local_db.generator.dart';
part 'local_db.query.dart';

class LocalDb implements DisposeClass {
  LocalDb._();

  static final LocalDb _instance = LocalDb._();

  static LocalDb get instance => _instance;

  Database? _database;

  final int _dbVersion = 1;

  int get siteId => LoginUtil.instance.siteId;

  Future<void> initDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'pos_billing.db');
      _database = await openDatabase(
        path,
        version: _dbVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) => onDBCreate(db),
        onOpen: kDebugMode ? onDBCreate : null,
        onUpgrade: onDBUpgrade,
      );
    } catch (e) {
      _database = null;
      _sqlLog(e);
    }
  }

  Future<bool> insertRecordsIndDb<T>({
    required List<Map<String, Object?>> data,
    required String table,
  }) async {
    if (_database == null) {
      return false;
    }
    return await insertRecords(data: data, table: table, db: _database!);
  }

  @override
  FutureOr<void> dispose() async {
    _database?.close();
  }

  final Map<String, ValueChanged<Set<MasterDataType>>> _dbChangeCallBacks = {};

  void registerdbChangeCallBacks({
    required String tag,
    required ValueChanged<Set<MasterDataType>> onChange,
  }) {
    // if (App.isNotMobileDevice) return;
    _dbChangeCallBacks[tag] = onChange;
  }

  void removedbChangeCallBacks({required String tag}) {
    _dbChangeCallBacks.remove(tag);
  }

  void notifybChangeCallBacks(Set<MasterDataType> dataChangeIn) {
    if (dataChangeIn.isEmpty) return;
    if (kDebugMode) {
      (
        "dataChangeIn",
        dataChangeIn,

        // StackTrace.current,
      ).toString().developerLog();
    }

    if (App.isMobileDevice) {
      if (_database == null) return;

      for (var callbacks in _dbChangeCallBacks.entries) {
        callbacks.value.call(dataChangeIn);
      }
    } else {
      EasyDebounce.debounce(
        "notifybChangeCallBacks",
        const Duration(milliseconds: 600),
        () {
          for (var callbacks in _dbChangeCallBacks.entries) {
            callbacks.value.call(dataChangeIn);
          }
        },
      );
    }
  }

  Future<String?> _runLastSyncQueryV2({required String query}) async {
    if (query.isEmpty) return null;
    try {
      final resp =
          await _database?.database.rawQuery(query.replaceAll("\n", " "), []) ??
          [];
      if (resp.isNotEmpty) {
        return DateTime.tryParse(
          (resp.first.values.first as String?) ?? "",
        )?.toINDDateTime.dateTimeStanderedFormat;
      }
    } catch (e) {
      return (null);
    }
    return (null);
  }

  Future<Map<String, dynamic>> getAllLastSyncV2({
    required List<MasterDataType> needMasters,
  }) async {
    Map<String, dynamic> lastSyncs = {};

    Map<MasterDataType, String> masterQeuryMap = {
      MasterDataType.itemInfo:
          "SELECT max(updatedOn) as lastSync FROM itemInfo WHERE standId = $siteId",
    };

    for (var type in needMasters) {
      lastSyncs[type.requirementKey] = 1;
      lastSyncs[type.lastSyncOnKey] = await _runLastSyncQueryV2(
        query: masterQeuryMap[type] ?? "",
      );
    }

    return lastSyncs;
  }
}
