part of 'itemwise_daily_sale_screen.dart';

class ItemWiseDailySaleUtil implements StatefulUtil {
  ValueNotifier<DateTimeRange> dateRangeNotifier = ValueNotifier(
    _initialRange(),
  );

  ValueNotifier<List<ItemwiseSaleReport>?> historyNotifier = ValueNotifier(
    null,
  );

  final login = LoginUtil.instance;

  Future<void> onTapDateRangeChange(DateTimeRange val) async {
    dateRangeNotifier.value = val;
    getSiteWiseHistory();
  }

  (
    num onlineItemCount,
    num onlineItemAmount,
    num cashItemCount,
    num cashItemAmount,
    num totalItemCount,
    num totalItemAmount,
  )
  getGrandTotal() {
    num onlineItemCount = 0;
    num onlineItemAmount = 0;
    num cashItemCount = 0;
    num cashItemAmount = 0;
    num totalItemCount = 0;
    num totalItemAmount = 0;

    for (var e in historyNotifier.value ?? <ItemwiseSaleReport>[]) {
      onlineItemCount += e.onlineItemCount;
      onlineItemAmount += e.onlineItemAmount;
      cashItemCount += e.cashItemCount;
      cashItemAmount += e.cashItemAmount;
      totalItemCount += e.totalItemCount;
      totalItemAmount += e.totalItemAmount;
    }

    return (
      onlineItemCount,
      onlineItemAmount,
      cashItemCount,
      cashItemAmount,
      totalItemCount,
      totalItemAmount,
    );
  }

  Future<void> getSiteWiseHistory() async {
    historyNotifier.value = null;
    final user = login.userNotifier.value;
    historyNotifier.value = await RemoteSource.instnace
        .getDailyItemWiseSaleReport(
          dateRange: dateRangeNotifier.value,
          userId: user.role.isOwnerOrAdmin ? 0 : user.userId,
        );
  }

  Future<void> onTapExcel() async {
    List<ItemwiseSaleReport> data = historyNotifier.value ?? [];
    List<Map<String, dynamic>> excelData = [];
    for (var x in data) {
      excelData.add(x.toExcelData());
    }

    await createExcelFile(excelData, fileNamePrefix: "ItemWiseSale");
  }

  @override
  void onPageClose() {
    // TODO: implement onPageClose
  }

  @override
  void onPageInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSiteWiseHistory();
    });
  }
}

DateTimeRange _initialRange() {
  final now = DateTime.now();
  return DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
}
