// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/data_source/cache/salereceipt_info_cache_data.dart';
import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/models/sale/receipt_item.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/common/singletons/receipt_no_cache.dart';
import 'package:pos_billing/common/singletons/unique_code_v2.dart';
import 'package:pos_billing/config/enums/payment_mode.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class CreateReceiptUtil implements StatefulUtil {
  final BuildContext context;

  CreateReceiptUtil({required this.context});

  List<ItemInfo> allItems = [];

  ValueNotifier<List<ReceiptItem>> showItemsNotifier = ValueNotifier([]);
  ValueNotifier<PaymentMode> paymentModeNotifier = ValueNotifier(
    PaymentMode.cash,
  );

  late SocketIoHandler socket;
  final printer = BlueThurmalPrint.instance;
  final login = LoginUtil.instance;

  String _saleUID = UniqueCodeV2.receiptUUID();

  (int qty, double amt) getGrandTotal() {
    int qty = 0;
    double amt = 0;
    for (ReceiptItem e in showItemsNotifier.value) {
      qty += e.itemQuantity;
      amt += e.itemAmount;
    }

    return (qty, amt);
  }

  void onTapDecrement(ReceiptItem val) {
    int itemQty = val.itemQuantity;

    if (itemQty > 0) {
      itemQty += -1;
      val.itemQuantity = itemQty;
      refreshList();
    }
  }

  void onTapIncrement(ReceiptItem val) {
    int itemQty = val.itemQuantity;
    itemQty += 1;

    val.itemQuantity = itemQty;

    refreshList();
  }

  void onPaymentModeChange(PaymentMode mode) {
    paymentModeNotifier.value = mode;
  }

  void refreshList() {
    showItemsNotifier.notifyListeners();
  }

  void onTapClear() {
    _saleUID = UniqueCodeV2.receiptUUID();
    final allowedSaleIds = login.userNotifier.value.allowedItemsForSale;
    showItemsNotifier.value = allItems
        .where(
          (e) => allowedSaleIds.isEmpty || allowedSaleIds.contains(e.itemId),
        )
        .map((e) => ReceiptItem.fromItemMaster(e))
        .toList();
    paymentModeNotifier.value = PaymentMode.cash;
    refreshList();
  }

  Future<(bool status, String message)> saveAllReceipts(
    ReceiptInfo receiptInfo,
  ) async {
    if (socket.isConnected) {
      final (s, m) = await RemoteSource.instnace.saveAllReceipts([receiptInfo]);
      if (s) {
        return (s, m);
      }
    }
    return SalereceiptInfoCacheData.instance.saveInLocal(receiptInfo);
  }

  Future<void> printReceipt() async {
    final items = showItemsNotifier.value
        .where((e) => e.itemQuantity > 0)
        .toList();
    final (qty, amt) = getGrandTotal();
    final user = login.userNotifier.value;
    if (items.isEmpty) {
      "Please add some items".showToast;
      return;
    }

    if ("".boxBluetoothDeviceCustomInfo.isEmpty) {
      "Please select printer first".showToast;
      return;
    }

    final receiptInfo = ReceiptInfo(
      saleUID: _saleUID,
      saleOn: DateTime.now(),
      totalItems: qty,
      totalAmount: amt,
      receiptItems: items,
      saleBy: user.userId,
      saleByFullName: user.userFullName,
      siteId: user.siteId,
      paymentMode: paymentModeNotifier.value,
    );

    LoadingDialogue.show();
    final (saveStatus, saveMessage) = await saveAllReceipts(receiptInfo);
    LoadingDialogue.hide();
    saveMessage.showToast;
    if (saveStatus) {
      final receiptCopy = receiptInfo.copyWith(
        tokenNumber: ReceiptNoCache.get(receiptInfo.saleUID),
      );
      onTapClear();
      final sts = await printer.printgeneralCounterToken(
        receiptInfo: receiptCopy,
      );

      if (!sts.status) {
        sts.msj.showToast;
      }
    }
  }

  Future<void> getAllItems() async {
    allItems = await RemoteSource.instnace.getActiveItems();
  }

  @override
  void onPageClose() {
    SocketIoHandler.removeCurrentSoket();
  }

  @override
  void onPageInit() {
    socket = SocketIoHandler.getCurrentUserSoket();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await socket.connectToSoket();
      "connectToSoket : $status".developerLog();
      await getAllItems();
      onTapClear();
    });
  }
}
