part of 'sitewise_history_screen.dart';

class SitewiseHistoryUtil implements StatefulUtil {
  ValueNotifier<DateTimeRange> dateRangeNotifier = ValueNotifier(
    _initialRange(),
  );

  ValueNotifier<List<ReceiptInfo>?> historyNotifier = ValueNotifier(null);

  late SocketIoHandler socketIoHandler;
  final login = LoginUtil.instance;

  Future<void> onTapDateRangeChange(DateTimeRange val) async {
    dateRangeNotifier.value = val;
    getSiteWiseHistory();
  }

  Future<void> getSiteWiseHistory() async {
    historyNotifier.value = null;
    final user = login.userNotifier.value;
    historyNotifier.value = await RemoteSource.instnace.getSaleHistoryWithItems(
      dateRange: dateRangeNotifier.value,
      userId: user.role.isOwnerOrAdmin ? 0 : user.userId,
    );
  }

  Future<void> onTapExcel() async {
    List<ReceiptInfo> data = historyNotifier.value ?? [];
    List<Map<String, dynamic>> excelData = [];
    for (var x in data) {
      excelData.addAll(x.toExcelRow());
    }
    "onTapExcel : ${excelData.length}".developerLog();

    await createExcelFile(excelData, fileNamePrefix: "SaleHistory");
  }

  @override
  void onPageClose() {}

  @override
  void onPageInit() {
    socketIoHandler = SocketIoHandler.getCurrentUserSoket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSiteWiseHistory();
    });
  }
}

DateTimeRange _initialRange() {
  final now = DateTime.now();
  return DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
}
