part of 'item_history_screen.dart';

class ItemHistoryUtil implements StatefulUtil {
  final BuildContext context;

  ItemHistoryUtil({required this.context});

  List<ItemInfo> allItems = [];

  ValueNotifier<List<ItemInfo>?> showItems = ValueNotifier(null);

  Future<void> getItemMasters() async {
    allItems = await RemoteSource.instnace.getItemMasters();
    showItems.value = allItems;
  }

  Future<void> onAddUpdateitem([ItemInfo? preInfo]) async {
    AddUpdateItemDialogue.show(context, preInfo);
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
