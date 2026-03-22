part of 'item_history_screen.dart';

class ItemHistoryUtil implements StatefulUtil {
  final BuildContext context;

  ItemHistoryUtil({required this.context});

  List<ItemInfo> allItems = [];
  final remoteSource = RemoteSource.instnace;

  ValueNotifier<List<ItemInfo>?> showItems = ValueNotifier(null);

  Future<void> getItemMasters() async {
    showItems.value = null;
    allItems = await remoteSource.getActiveItems();
    showItems.value = allItems;
  }

  Future<void> onTapItem(ItemInfo item) async {
    final option = await showGeneralOptionSheet(
      context: context,
      options: [AppGeneralOption.edit, AppGeneralOption.delete],
    );

    if (option.isedit) {
      await onAddUpdateitem(item);
    }
    if (option.isdelete) {
      await deleteItem(item);
    }
  }

  Future<void> deleteItem(ItemInfo item) async {
    if (!await makeconfirmation()) {
      return;
    }

    LoadingDialogue.show();
    final (status, message) = await remoteSource.deleteItem(
      itemId: item.itemId,
    );
    if (status) {
      await getItemMasters();
    }
    LoadingDialogue.hide();
    message.showToast;
  }

  Future<void> onAddUpdateitem([ItemInfo? preInfo]) async {
    final status = await App.to(
      (_) => AddUpdateItemScreen(preInfo: preInfo),
      routeName: AddUpdateItemScreen.routeName,
    );
    if (status == true) {
      await getItemMasters();
    }
  }

  @override
  void onPageClose() {}

  @override
  void onPageInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getItemMasters();
    });
  }
}
