import 'dart:convert';

import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';

class SalereceiptInfoCacheData {
  SalereceiptInfoCacheData._();

  static final SalereceiptInfoCacheData _instance =
      SalereceiptInfoCacheData._();

  static SalereceiptInfoCacheData get instance => _instance;

  List<ReceiptInfo> _unSyncedData = [];

  Future<(bool, String)> saveInLocal(ReceiptInfo val) async {
    _unSyncedData.add(val);
    _saveUnsync();
    return (true, "Record saved locally !");
  }

  void _saveUnsync() {
    jsonEncode(_unSyncedData.map((e) => e.toMap()).toList()).boxunsyncedSale;
  }

  List<ReceiptInfo> fetchUnSyncedData() {
    try {
      final encoded = "".boxunsyncedSale;
      if (encoded.isEmpty) {
        return [];
      }

      _unSyncedData = ReceiptInfo.fetchList(
        jsonDecode(encoded),
        fromServer: false,
      );
      return _unSyncedData;
    } catch (e) {
      return [];
    }
  }

  bool _isSyncing = false;

  Future<void> syncLocalData() async {
    if (_isSyncing || _unSyncedData.isEmpty) {
      return;
    }
    _isSyncing = true;
    final local = [..._unSyncedData];

    final (status, _) = await RemoteSource.instnace.saveAllReceipts(local);
    if (status) {
      for (var e in local) {
        _unSyncedData.remove(e);
      }
    }
    _saveUnsync();
    _isSyncing = false;
  }
}
