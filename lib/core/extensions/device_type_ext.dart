import 'package:pos_billing/config/enums/device_type_enum.dart';

extension AppDeviceTypeExt<T> on DeviceType {
  T switchByAproxType({required T value, T? onMobile, T? onTab, T? onDesktop}) {
    if (isMobile) {
      return onMobile ?? value;
    }
    if (isMobile || isTablet) {
      return onTab ?? value;
    }
    if (isMobile || isTablet || isDesktop) {
      return onDesktop ?? value;
    }
    return value;
  }
}
