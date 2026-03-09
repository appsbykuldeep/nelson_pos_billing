import 'package:get_storage/get_storage.dart';

final _box = GetStorage();

extension KDLocalDb on String {
  String get boxIPAddress => _finder("localIPAddress");
  String get boxPrinterPaperSize => _finder("PrinterPaperSize");
  String get boxActiveThemeID => _finder("ActiveThemeID");
  String get boxFullScreenMode => _finder("boxFullScreenMode");
  String get boxInstallTime => _finder("boxInstallTime");
  String get boxCurrentCountryCallCode => _finder("boxCurrentCountryCallCode");
  String get boxLoggedUserInfo => _finder("boxLoggedUserInfo");
  String get boxCurrentUserDetails => _finder("boxCurrentUserDetails");
  String get boxdeviceToken => _finder("boxdeviceToken");
  String get boxunsyncedSale => _finder("unsyncedSale");
  String get boxGenTokenNumber {
    final d = DateTime.now();
    return _finder("genTokenNumber_${d.year}_${d.month}_${d.day}");
  }

  String get boxBluetoothDeviceCustomInfo =>
      _finder("BluetoothDeviceCustomInfo");

  String _finder(String key) {
    if (isNotEmpty) {
      if (this == "--") {
        _box.write(key, '');
      } else {
        _box.write(key, this);
      }
    }

    return _box.read(key) ?? "";
  }
}
