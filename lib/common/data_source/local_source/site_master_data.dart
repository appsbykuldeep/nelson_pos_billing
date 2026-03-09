import 'dart:typed_data';

import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/data_source/local_source/local_db.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/handle_compress.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/config/enums/api_progess.dart';
import 'package:pos_billing/config/enums/master_data_enum.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class SiteMasterData {
  SiteMasterData._();

  static final SiteMasterData _instance = SiteMasterData._();

  static SiteMasterData get instnace => _instance;

  static final _login = LoginUtil.instance;
  static final _db = LocalDb.instance;

  Future<void> getMasterDataByType({
    required List<MasterDataType> needMasters,
    required showloading,
    required isDeepRefresh,
    required Future<void> Function()? beforeSaveInDB,
  }) async {
    if (App.isNotMobileDevice) return;
    if (!_login.isLoggedIn) return;

    final mastersLastSyncs = await filterMasterDataRequirement(
      needMasters: needMasters,
      isDeepRefresh: isDeepRefresh,
    );

    final currentSoket = SocketIoHandler.currentSocket;
    if (currentSoket == null) {
      return;
    }

    mastersLastSyncs.addAll(_login.userDetailsMap);

    final resp = await currentSoket.emitWithResponse(
      SoketEvents.getAllMasterDataV2,
      mastersLastSyncs,
      timeOutSec: 600,
      progessStatus: LoadingDialogue.setProgressStatus,
    );

    if (resp.soketData is List<int> || resp.soketData is Uint8List) {
      LoadingDialogue.setProgressStatus(ApiProgessStatus.wait);

      final json = HandleCompress.decodeZLibAndGetJson(resp.soketData);

      if (json is Map<String, dynamic>) {
        await fetchsaveMasterOnMainThred(
          beforeSaveInDB: beforeSaveInDB,
          resultData: json,
        );
      }

      return;
    }

    if (resp.soketData is Map<String, dynamic>) {
      await fetchsaveMasterOnMainThred(
        beforeSaveInDB: beforeSaveInDB,
        resultData: resp.soketData,
      );
      return;
    }
  }

  Future<Map<String, dynamic>> filterMasterDataRequirement({
    List<MasterDataType> needMasters = MasterDataType.mainMasterData,
    bool isDeepRefresh = false,
  }) async {
    Map<String, dynamic> filterLastSyncs = {};
    if (!_login.isLoggedIn) {
      return filterLastSyncs;
    }

    if (!isDeepRefresh) {
      filterLastSyncs = await _db.getAllLastSyncV2(needMasters: needMasters);
    } else {
      for (var master in needMasters) {
        filterLastSyncs[master.requirementKey] = 1;
      }
    }

    return filterLastSyncs;
  }

  Future<void> fetchsaveMasterOnMainThred({
    Future<void> Function()? beforeSaveInDB,
    required Map<String, dynamic> resultData,
  }) async {
    if (App.isNotMobileDevice) {
      "Must handle fetchsaveMaster".developerLog();
      return;
    }
    await beforeSaveInDB?.call();
    await _db.initDB();
    final dataChangedIn = await fetchsaveMaster(
      resultData: resultData,

      progressStatus: LoadingDialogue.setProgressValueV2,
    );

    _db.notifybChangeCallBacks(dataChangedIn);
  }

  static Future<Set<MasterDataType>> fetchsaveMaster({
    required Map<String, dynamic> resultData,
    void Function(int count, int total)? progressStatus,
  }) async {
    Map<MasterDataType, int> dataChangedIn = {};

    int totalData = resultData.getint("totaldatacount");
    int savedCount = 0;

    void addDataChange(MasterDataType type, int val) {
      savedCount += val;
      final count = (dataChangedIn[type] ?? 0) + val;
      dataChangedIn[type] = count;
      if (totalData > 0) {
        progressStatus?.call(savedCount, totalData);
      }
    }

    try {
      await saveDataListInDb(
        type: MasterDataType.itemInfo,
        allMasterData: resultData,
        onDataChange: addDataChange,
        parseList: (data) => ItemInfo.fetchList(
          data,
          fromServer: true,
        ).map((e) => e.toDbMap()).toList(),
      );
    } catch (e) {
      (e.toString()).developerLog();
    }
    return dataChangedIn.keys.toSet();
  }

  static Future<bool> saveDataListInDb({
    required MasterDataType type,
    required Map<String, dynamic> allMasterData,
    required List<Map<String, dynamic>> Function(dynamic data) parseList,
    required void Function(MasterDataType type, int val) onDataChange,
  }) async {
    final parsedData = parseList(allMasterData[type.requirementKey]);
    final status = await _db.insertRecordsIndDb(
      data: parsedData,
      table: type.tableName,
    );

    if (status) {
      onDataChange.call(type, parsedData.length);
    }
    return status;
  }
}
