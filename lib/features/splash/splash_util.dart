part of 'splash_screen.dart';

class SplashUtil implements StatefulUtil {
  final String? externalDisplayUID;
  final BuildContext context;
  SplashUtil({this.externalDisplayUID, required this.context});

  bool _prelogin = false;
  final login = LoginUtil.instance;

  Future<void> initApp() async {
    HttpCertificate.call();
    await DevicePackageDetails.instance.setDeviceDetails();
    await AppPermissions.takeAllPermissions();

    await _initBasics();

    portraitModeOnly();
    InternetConnectivity.instance.onPageInit();
    // await AppAdsHandler.instance.initialized();

    _prelogin = await login.makePreLogin();

    // if (kDebugMode) {
    //   "1".boxIsIntroViewed;
    // }

    if (1 == 1) {
      final (routeName, page) = getinitialRoute();
      App.pushAndRemoveAll((p0) => page, routeName: routeName);
      await Future.delayed(const Duration(milliseconds: 400));
      checkForargumentsAndNavigate();
    }
    BluetoothConnectivity.instance.onPageInit();
  }

  void checkForargumentsAndNavigate() {
    // final routeSetting = context.routeSettings;
    // if (routeSetting == null) return;
    // Map<String, dynamic> mapArgs = {};
    // if ((routeSetting.arguments is Map<String, dynamic>)) {
    //   mapArgs = Map<String, dynamic>.from(routeSetting.arguments as dynamic);
    // }

    // final notiType = NotificationType.byValue(mapArgs.getString("parkingUID"));

    // if (ValetCheckinoutRequestsScreen.routeName.equalTo(routeSetting.name) ||
    //     notiType.isvaletCheckInOrOutRequest) {
    //   App.to(
    //     (x) => const ValetCheckinoutRequestsScreen(),
    //     routeName: ValetCheckinoutRequestsScreen.routeName,
    //     settings: RouteSettings(
    //       name: ValetCheckinoutRequestsScreen.routeName,
    //       arguments: mapArgs,
    //     ),
    //   );
    // }
  }

  // TODO: add number related reporing in dashboard.
  Future<void> _initBasics() async {
    List<Future> independent = [
      PdfHelper.instance.init(),

      LocalDb.instance.initDB(),
    ];

    await Future.wait(independent);
  }

  (String, Widget) getinitialRoute() {
    if (_prelogin) {
      return (CreateReceiptScreen.routeName, const CreateReceiptScreen());
    }

    return (LoginScreen.routeName, const LoginScreen());
  }

  // String? getinitialRoute() {
  //   // if (!kReleaseMode) return null;

  //   if (_prelogin) {
  //     if (_loginCtrl.userRole.isDriver) {
  //       return ValetCheckinoutRequestsScreen.routeName;
  //     }
  //     return DashBoardPage.routeName;
  //   }
  //   if ("".boxIsIntroViewed != "1") {
  //     return IntroductionPage.routeName;
  //   }
  //   return LoginPage.routeName;
  // }

  @override
  void onPageClose() {
    // TODO: implement onPageClose
  }

  @override
  void onPageInit() {
    initApp();
  }
}
