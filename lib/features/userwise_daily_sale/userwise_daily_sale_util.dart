part of 'userwise_daily_sale_screen.dart';

class UserwiseDailySaleUtil implements StatefulUtil {
  ValueNotifier<DateTimeRange> dateRangeNotifier = ValueNotifier(
    _initialRange(),
  );

  ValueNotifier<List<UserWiseSaleReport>?> historyNotifier = ValueNotifier(
    null,
  );

  final login = LoginUtil.instance;

  Future<void> onTapDateRangeChange(DateTimeRange val) async {
    dateRangeNotifier.value = val;
    getSiteWiseHistory();
  }

  Future<void> getSiteWiseHistory() async {
    historyNotifier.value = null;
    final user = login.userNotifier.value;
    historyNotifier.value = await RemoteSource.instnace
        .getDailyUserWiseSaleReport(
          dateRange: dateRangeNotifier.value,
          userId: user.role.isOwnerOrAdmin ? 0 : user.userId,
        );
  }

  Future<void> onTapExcel() async {
    List<UserWiseSaleReport> data = historyNotifier.value ?? [];
    List<Map<String, dynamic>> excelData = [];
    for (var x in data) {
      excelData.add(x.toExcelData());
    }

    await createExcelFile(excelData, fileNamePrefix: "UserWiseSale");
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
