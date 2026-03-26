part of 'main.dart';

class MainAppUtil extends StatefulUtil {
  // final _isoNumberDetector = NumberDetectionInIsolate.instance;
  final _localdb = LocalDb.instance;
  final _printer = BlueThurmalPrint.instance;

  final _internet = InternetConnectivity.instance;
  final _bluetooth = BluetoothConnectivity.instance;
  final _bluetoothDevices = BluedeviceHandler.instance;
  // final _nfcHandler = NFCKitHandler.instance;

  static ValueNotifier<ActiveThemeMode> activeTheme = ValueNotifier(
    ActiveThemeMode.byId("".boxActiveThemeID),
  );
  static ValueNotifier<FullScreenMode> screenMode = ValueNotifier(
    FullScreenMode.byId("".boxFullScreenMode),
  );

  void _setScreenMode() {
    if (screenMode.value.ison) {
      fullScreenMode();
    } else {
      showStatusBar();
    }
  }

  void _setInstallTime() {
    if ("".boxInstallTime == "") {
      final id = DateTime.now().custumDateFormat("yyMMddHHmmss");
      id.boxInstallTime;
    }
  }

  @override
  void onPageClose() {
    _printer.onPageClose();
    _internet.onPageClose();
    _bluetooth.onPageClose();
    _bluetoothDevices.onPageClose();
    _localdb.dispose();
    // _deepLink.dispose();
    SocketIoHandler.removeCurrentSoket();
    WakelockPlus.disable();
  }

  @override
  void onPageInit() async {
    // _isoNumberDetector.onPageInit();
    _printer.onPageInit();
    _bluetoothDevices.onPageInit();
    checkForUpdate();
    _setScreenMode();
    _setInstallTime();
    WakelockPlus.enable();

    VibrateHandler.instance.initialized();
    SalereceiptInfoCacheData.instance.syncLocalData();
  }
}
