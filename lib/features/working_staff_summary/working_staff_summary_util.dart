part of 'working_staff_summary_page.dart';

class WorkingStaffSummaryUtil extends StatefulUtil {
  ValueNotifier<List<WorkstaffInfoModel>?> showWorkStaffNotifier =
      ValueNotifier<List<WorkstaffInfoModel>?>(null);
  // final _db = LocalDB.instance;

  final standInfo = LoginUtil.instance.standDetailsNotifier.value;
  final userInfo = LoginUtil.instance.userNotifier.value;
  StreamSubscription? soketSubs;

  List<String> get onlineUsersCodes =>
      _socketIoHandler.onlineUsersNotifier.value;

  late SocketIoHandler _socketIoHandler;

  List<ItemInfo> siteItems = [];

  List<WorkstaffInfoModel> get showWorkStaff =>
      (showWorkStaffNotifier.value ?? []);

  Future<void> getWorkStaffList({bool isAutoRefresh = false}) async {
    if (!isAutoRefresh) {
      showWorkStaffNotifier.value = null;
    }

    showWorkStaffNotifier.value =
        (await RemoteSource.instnace.getWorkingStaffs())
            .where((e) => e.userId != userInfo.userId && !e.role.isOwner)
            .toList();

    // showWorkStaffNotifier.value = (await DataProvider.instance
    //     .getWorkingStaffInfoList(
    //       onlineUsersCodes: onlineUsersCodes,
    //       currentRole: userInfo.role,
    //     ));
  }

  Future<void> onAddEditWorkStaff([WorkingStaffMaster? staff]) async {
    if (InternetConnectivity.checkNotAvailableAndShowDialogue()) {
      return;
    }

    final status = await App.to(
      (_) => WorkStaffPage(staff: staff, siteItems: siteItems),
      routeName: WorkStaffPage.routeName,
    );
    if (status != null && status == true) {
      LoadingDialogue.show();
      await getWorkStaffList();
      LoadingDialogue.hide();
    }
  }

  // Future<void> getOnlineUsersCodes() async {
  //   final isconnected = _socketIoHandler?.isConnected ?? false;
  //   if (!isconnected || _socketIoHandler == null) {
  //     onlineUsersCodes.clear();
  //     return;
  //   } else {
  //     final resp = await _socketIoHandler!.emitWithResponse(
  //       SoketEvents.getOnlineStandStaffUserCodes,
  //       _db.standId,
  //     );
  //     if (resp.responseData is List<dynamic>) {
  //       onlineUsersCodes = List<String>.from(resp.responseData).toSet();
  //     }
  //   }
  // }

  Future<void> getsiteItems() async {
    LoadingDialogue.show();
    siteItems = await RemoteSource.instnace.getActiveItems();
    LoadingDialogue.hide();
  }

  @override
  void onPageClose() {
    showWorkStaffNotifier.dispose();
    soketSubs?.cancel();
  }

  @override
  void onPageInit() {
    _socketIoHandler = SocketIoHandler.getCurrentUserSoket();
    soketSubs = _socketIoHandler.soketStream.listen((data) async {
      if (data.event.equalTo(SoketEvents.updateOnlineStandUsers)) {
        EasyDebounce.debounce(
          "updateOnlineStandUsersWSS",
          const Duration(seconds: 1),
          () async {
            await getWorkStaffList(isAutoRefresh: true);
          },
        );
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await getsiteItems();
      await getWorkStaffList();
    });
  }
}
