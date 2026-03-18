part of 'add_working_staff_screen.dart';

class AddWorkingStaffUtil extends StatefulUtil {
  final WorkingStaffMaster selectedWorkStaff;
  final bool isEditmode;
  AddWorkingStaffUtil({
    required this.selectedWorkStaff,
    required this.isEditmode,
  });

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();

  TextEditingController pwCtrl = TextEditingController(text: '12345');
  ValueNotifier<CurrentStatus> selectedStatus = ValueNotifier<CurrentStatus>(
    CurrentStatus.active,
  );

  ValueNotifier<List<int>> allowedVehicleCategoriesNotifier = ValueNotifier([]);
  List<ItemInfo> standVehicleCategories = [];

  late final SocketIoHandler soketIo = SocketIoHandler.getCurrentUserSoket();

  ValueNotifier<UserRole> selectedUserRole = ValueNotifier<UserRole>(
    UserRole.none,
  );

  final login = LoginUtil.instance;
  final standInfo = LoginUtil.instance.standDetailsNotifier.value;
  final user = LoginUtil.instance.userNotifier.value;

  // final db = LocalDB.instance;

  bool get isBlockedSelected => selectedStatus.value.isInactive;

  Future<void> _setVehicleategoryMaster() async {
    standVehicleCategories = <ItemInfo>{...login.currentItems.value}.toList();
    // standVehicleCategories = (await db.getVehicalCategoryMaster())
    //     .where((e) => e.standId > 0)
    //     .toList();
  }

  void onChangedVehicalCategory(bool? x, ItemInfo e) {
    final preList = [...allowedVehicleCategoriesNotifier.value];
    if (x ?? false) {
      preList.add(e.itemId);
    } else {
      preList.remove(e.itemId);
    }

    allowedVehicleCategoriesNotifier.value = preList;
  }

  void onUserRoleChange(UserRole value) {
    hideKeyboard();
    selectedUserRole.value = value;
  }

  void addEditSetup() {
    nameCtrl.text = selectedWorkStaff.fullName;
    mobileCtrl.text = selectedWorkStaff.mobile;

    if (isEditmode) {
      selectedStatus.value = selectedWorkStaff.currentStatus;
    }

    allowedVehicleCategoriesNotifier.value =
        selectedWorkStaff.allowedItemsForSale;

    selectedUserRole.value = selectedWorkStaff.role;
  }

  void onChangeActiveStatus(CurrentStatus status) {
    selectedStatus.value = status;
  }

  void onTapOutSide() {
    hideKeyboard();
  }

  Future<void> resetPassword() async {
    const content =
        "Would you like to <b>reset</b> the password to <b>12345</b> ?";
    if (!await makeconfirmation(content: content)) return;
    final body = {"userId": selectedWorkStaff.userId};
    final resp = await soketIo.emitWithResponse(
      SoketEvents.resetUserPassword,
      body,
    );
    // if (resp.resultStatus) {
    //   Get.back();
    // }
    resp.resultMessage.showAlert;
  }

  Future<void> createUpdateWorkStaff() async {
    final role = selectedUserRole.value;
    final mobile = mobileCtrl.text.trim().toLowerCase();
    final name = nameCtrl.trimText;

    List<int> allowedVehicleCategories = [];

    if (name.length < 3) {
      "Please fill full name".showAlert;
      return;
    }

    if (mobile.length < 6) {
      "Please create username with least 6 character.".showAlert;
      return;
    }

    if (role.isNone) {
      "Please select role.".showAlert;
      return;
    }

    if (role.isStaff) {
      // taking long way
      // It will also remove non active vehicle ids.
      final ac = allowedVehicleCategoriesNotifier.value;
      allowedVehicleCategories = standVehicleCategories
          .where((e) => ac.contains(e.itemId))
          .map((e) => e.itemId)
          .toList();
    }

    final body = {
      "userId": selectedWorkStaff.userId,
      "fullName": name,
      "siteId": standInfo.siteId,
      "mobile": mobile,
      "RoleId": role.id,
      "ActiveStatus": selectedStatus.value.id,
      "allowedItemsForSale": allowedVehicleCategories.join(","),
    };

    if (!await makeconfirmation()) return;

    final resp = await soketIo.emitWithResponse(
      SoketEvents.addEditWorkStaff,
      body,
    );
    if (resp.resultStatus) {
      App.back(true);
      resp.resultMessage.showToast;
      if (isBlockedSelected) {
        soketIo.emitEventToSiteUsers(
          event: SoketEvents.logoutUser,
          userIds: [selectedWorkStaff.userId],
        );
      }
    } else {
      resp.resultMessage.showAlert;
    }
  }

  Future<void> deleteWorkStaff() async {
    const content = "Do you want to <m>delete</m> this user ?";
    if (!await makeconfirmation(content: content)) return;
    LoadingDialogue.show();
    final resp = await soketIo
        .emitWithResponse(SoketEvents.deleteStandWorkStaff, {
          "userId": selectedWorkStaff.userId,
          "siteId": selectedWorkStaff.siteId,
          "deleteByUserId": user.userId,
        });
    LoadingDialogue.hide();
    if (resp.resultStatus) {
      App.back(true);
    }
    resp.resultMessage.showToast;
  }

  @override
  void onPageClose() {
    nameCtrl.dispose();
    mobileCtrl.dispose();

    pwCtrl.dispose();
  }

  @override
  void onPageInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setVehicleategoryMaster();
      addEditSetup();
    });
  }
}
