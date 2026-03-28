import 'package:flutter/material.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/models/sale_reports/itemwise_sale_report.dart';
import 'package:pos_billing/common/models/sale_reports/user_wise_sale_report.dart';
import 'package:pos_billing/common/models/workstaff/workstaff_info_model.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/singletons/receipt_no_cache.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';

class RemoteSource {
  RemoteSource._();

  static final RemoteSource _instance = RemoteSource._();

  static RemoteSource get instnace => _instance;

  final _login = LoginUtil.instance;

  Future<List<UserWiseSaleReport>> getDailyUserWiseSaleReport({
    required DateTimeRange dateRange,
    int userId = 0,
  }) async {
    final data = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.getDailyUserWiseSaleReport,
      {
        "siteId": _login.siteId,
        "fromDate": dateRange.start.toINDDateTime.fromdateFormat,
        "tillDate": dateRange.end.toINDDateTime.tilldateFormat,
        "userId": userId,
      },
    );

    return UserWiseSaleReport.fetchList(data.resultData, fromServer: true);
  }

  Future<List<ItemwiseSaleReport>> getDailyItemWiseSaleReport({
    required DateTimeRange dateRange,
    int userId = 0,
  }) async {
    final data = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.getDailyItemWiseSaleReport,
      {
        "siteId": _login.siteId,
        "fromDate": dateRange.start.toINDDateTime.fromdateFormat,
        "tillDate": dateRange.end.toINDDateTime.tilldateFormat,
        "userId": userId,
      },
    );

    return ItemwiseSaleReport.fetchList(data.resultData, fromServer: true);
  }

  Future<List<ReceiptInfo>> getSaleHistoryWithItems({
    required DateTimeRange dateRange,
    int userId = 0,
  }) async {
    final data = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.getSaleHistoryWithItems,
      {
        "siteId": _login.siteId,
        "fromDate": dateRange.start.toINDDateTime.fromdateFormat,
        "tillDate": dateRange.end.toINDDateTime.tilldateFormat,
        "userId": userId,
      },
    );

    return ReceiptInfo.fetchList(data.resultData, fromServer: true);
  }

  Future<List<ItemInfo>> getItemMasters() async {
    final data = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.getItemMasters,
      {"siteId": _login.siteId},
    );

    return ItemInfo.fetchList(data.resultData, fromServer: true);
  }

  Future<List<WorkstaffInfoModel>> getWorkingStaffs() async {
    final data = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.getWorkingStaffs,
      {"siteId": _login.siteId},
    );

    return WorkstaffInfoModel.fetchList(data.resultData, fromServer: true);
  }

  Future<List<ItemInfo>> getActiveItems() async {
    return (await getItemMasters())
        .where((e) => e.currentStatus.isActive)
        .toList();
  }

  Future<(bool status, String message)> saveAllReceipts(
    List<ReceiptInfo> receiptInfos,
  ) async {
    final resp = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.saveAllReceipts,
      {"dataList": receiptInfos.map((e) => e.toSyncMap()).toList()},
    );
    if (resp.resultStatus) {
      if (resp.resultData is Map<String, dynamic>) {
        ReceiptNoCache.parseBySyncData(resp.resultData['saveResponses']);
      }
    }

    return (resp.resultStatus, resp.resultMessage);
  }

  Future<(bool status, String message)> deleteItem({
    required int itemId,
  }) async {
    final resp = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.deleteItem,
      {"itemId": itemId, "siteId": _login.siteId, "userId": _login.userId},
    );

    return (resp.resultStatus, resp.resultMessage);
  }
}
