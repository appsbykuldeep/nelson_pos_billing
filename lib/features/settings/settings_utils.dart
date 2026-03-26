// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/dialogues/confirmation.dart';
import 'package:pos_billing/common/models/basic/permissions_model.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/config/enums/active_theme_mode.dart';
import 'package:pos_billing/config/enums/full_screen_mode.dart';
import 'package:pos_billing/config/enums/user_roles.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/system_chrome_fun.dart';
import 'package:pos_billing/features/change_password/change_password_page.dart';
import 'package:pos_billing/features/item_history/item_history_screen.dart';
import 'package:pos_billing/features/itemsie_daily_sale/itemwise_daily_sale_screen.dart';
import 'package:pos_billing/features/login/login_screen.dart';
import 'package:pos_billing/features/share_app/share_app_screen.dart';
import 'package:pos_billing/features/sitewise_history/sitewise_history_screen.dart';
import 'package:pos_billing/features/userwise_daily_sale/userwise_daily_sale_screen.dart';
import 'package:pos_billing/features/working_staff_summary/working_staff_summary_page.dart';
import 'package:pos_billing/main.dart';
import 'package:restart_app/restart_app.dart';

class SettingsUtils implements StatefulUtil {
  final BuildContext context;

  SettingsUtils({required this.context});

  final LoginUtil login = LoginUtil.instance;
  SiteDetail stand = LoginUtil.instance.standDetailsNotifier.value;
  static final _printCtrl = BlueThurmalPrint.instance;

  ValueNotifier<double?> walletBalance = ValueNotifier<double?>(null);

  FocusNode screenFocus = FocusNode();

  SocketIoHandler? socketIoHandler = SocketIoHandler.currentSocket;

  ValueNotifier<bool> isSocketConnected = SocketIoHandler.isSocketConnected;

  ValueNotifier<String> get profileImage => login.profileImage;

  bool get isIndianStand => login.isIndianStand;

  UserRole get userRole => login.userRole;

  Future<void> setWalletBalance() async {
    // if (login.isOwnerOrStandAdmin || login.staffWalletStatus.isdisable) return;
    // walletBalance.value = await db.getStaffWalletBalance(login.userCode);
  }

  void onTapChangePassword() {
    App.to(
      (_) => ChangePasswordPage(),
      routeName: ChangePasswordPage.routeName,
    );
  }

  void onTapWorkStaffs() {
    App.to(
      (_) => WorkStaffSummaryScreen(),
      routeName: WorkStaffSummaryScreen.routeName,
    );
  }

  void onTapItemHistory() {
    App.to((_) => ItemHistoryScreen(), routeName: ItemHistoryScreen.routeName);
  }

  void onTapSiteWiseTokenHistory() {
    App.to(
      (_) => SitewiseHistoryScreen(),
      routeName: SitewiseHistoryScreen.routeName,
    );
  }

  void onTapUserWiseDailySaleReport() {
    App.to(
      (_) => UserwiseDailySaleScreen(),
      routeName: UserwiseDailySaleScreen.routeName,
    );
  }

  void onTapItemWiseDailySaleReport() {
    App.to(
      (_) => ItemWiseDailySaleScreen(),
      routeName: ItemWiseDailySaleScreen.routeName,
    );
  }

  void onTapSaleHistoryReport() {
    App.to(
      (_) => SitewiseHistoryScreen(),
      routeName: SitewiseHistoryScreen.routeName,
    );
  }

  void onTapProfileImage() {
    final path = profileImage.value;
    if (!path.isLikeUrl) {
      return;
    }
    // App.to(
    //   (_) => FullScreenImage(
    //     apptitel: "Profile Image",
    //     path: path,
    //     canShare: true,
    //   ),
    //   routeName: FullScreenImage.routeName,
    // );
  }

  void onTapShareApp() {
    App.to((_) => const ShareAppPage(), routeName: ShareAppPage.routeName);
  }

  void restartApp() async {
    if (!kDebugMode) {
      await Restart.restartApp();
    }
  }

  void changeActiveThemeMode(ActiveThemeMode nextMode) async {
    // if (App.isNotMobileDevice) return;
    MainAppUtil.activeTheme.value = nextMode;
    if (nextMode.isdark) {
      "Switched to dark mode !".showToast;
    } else {
      "Switched to light mode !".showToast;
    }
    nextMode.id.boxActiveThemeID;
  }

  void toggleFullScreenMode(FullScreenMode nexMode) async {
    MainAppUtil.screenMode.value = nexMode;
    if (nexMode.ison) {
      showStatusBar();
      MainAppUtil.screenMode.value = FullScreenMode.off;
    } else {
      fullScreenMode();
      MainAppUtil.screenMode.value = FullScreenMode.on;
    }
    MainAppUtil.screenMode.value.id.boxFullScreenMode;
  }

  Future<void> onTapConnectPrinter() async {
    if (App.isNotMobileDevice) {
      _printCtrl.selectPrinter(refresh: true);
      return;
    }
    if (AppPermissions.bluetooth) {
      _printCtrl.selectPrinter(refresh: true);
    } else {
      "Please allow all permissions !".showToast;
      await AppPermissions.takeAllPermissions();
    }
  }

  void onTapTestPrint() async {
    final pStatus = await _printCtrl.testPrint();

    if (!pStatus.status) {
      pStatus.msj.showToast;
    }
  }

  Future<void> onTapLogOut() async {
    final confirm = await makeconfirmation(yestobutton: false);
    if (!confirm) return;
    App.pushAndRemoveAll(
      (_) => LoginScreen(),
      routeName: LoginScreen.routeName,
    );
    await Future.delayed(Duration(milliseconds: 400));
    SocketIoHandler.removeCurrentSoket();
    await login.onUserLogOut();
  }

  @override
  void onPageClose() {
    screenFocus.dispose();
  }

  @override
  void onPageInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setWalletBalance();
    });
  }
}
