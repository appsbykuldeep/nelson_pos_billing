import 'dart:async';

import 'package:pos_billing/common/abstract_classes/initialized_class.dart';
import 'package:pos_billing/common/data_source/local_source/local_db.dart';
import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/config/enums/master_data_enum.dart';

class ItemInfoCacheData implements InitializedClass, DisposeClass {
  ItemInfoCacheData._();

  static final ItemInfoCacheData _instance = ItemInfoCacheData._();

  static ItemInfoCacheData get instance => _instance;

  List<ItemInfo>? _allItemInfoCache;

  final localDb = LocalDb.instance;

  Future<List<ItemInfo>> getItemsInfo({bool force = false}) async {
    if (force || _allItemInfoCache == null) {
      _allItemInfoCache = await RemoteSource.instnace.getItemMasters();
    }

    return _allItemInfoCache ?? [];
  }

  @override
  FutureOr<void> dispose() {
    _allItemInfoCache = null;
    localDb.removedbChangeCallBacks(tag: "ItemInfoCacheData");
  }

  @override
  FutureOr<void> initialized() {
    localDb.registerdbChangeCallBacks(
      tag: "ItemInfoCacheData",
      onChange: (value) async {
        if (value.contains(MasterDataType.itemInfo)) {
          await getItemsInfo(force: true);
        }
      },
    );
  }
}
