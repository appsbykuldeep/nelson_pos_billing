import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/data_source/cache/salereceipt_info_cache_data.dart';
import 'package:pos_billing/common/data_source/local_source/local_db.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/base_api_handler.dart';
import 'package:pos_billing/common/singletons/bluedevice_handler.dart';
import 'package:pos_billing/common/singletons/bluetooth_connectivity.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/common/singletons/routeobserver.dart';
import 'package:pos_billing/common/singletons/vibrate_handler.dart';
import 'package:pos_billing/config/enums/active_theme_mode.dart';
import 'package:pos_billing/config/enums/full_screen_mode.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/functions/app_update.dart';
import 'package:pos_billing/core/functions/system_chrome_fun.dart';
import 'package:pos_billing/features/splash/splash_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'mainapp_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

/// Must check bellow points
/// [App.company]
/// [ BaseApiHandler.apiConfig]
/// ```bash
/// flutter build appbundle --release --obfuscate --split-debug-info=others/build_symbols
/// shorebird release android
/// shorebird patch android
/// ```
///

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MainAppUtil util = MainAppUtil();
  @override
  void initState() {
    util.onPageInit();
    super.initState();
  }

  @override
  void dispose() {
    util.onPageClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MainAppUtil.activeTheme,
      builder: (context, theme, child) {
        return MaterialApp(
          title: App.company.title,
          theme: App.company.lightTheme,
          darkTheme: App.company.darkTheme,
          debugShowCheckedModeBanner: false,
          themeMode: theme.isdark ? ThemeMode.dark : ThemeMode.light,
          scaffoldMessengerKey: App.scaffoldMessengerKey,
          navigatorKey: App.navigatorKey,
          locale: const Locale('en', "IND"),
          navigatorObservers: [
            RouteObserverService.instance,
            RouteObserverService.modalRouteObserver,
          ],

          home: SplashScreen(),
        );
      },
    );
  }
}

/*
  

flutter run --no-enable-impeller


-- For Optimize Svg image
dart run vector_graphics_compiler -i others/svg_icons/portrait_outline.svg -o assets/optimized_svg/portrait_outline.svg.vec



dart run vector_graphics_compiler -i others/svg_icons/selling_tricycle.svg -o assets/vehicle_vec_icons/selling_tricycle.svg.vec

 SvgPicture(
            AssetBytesLoader(data.svgicon),
            height: 30,
          ),

ColorFilter.mode(_theme.primaryColor, BlendMode.srcIn)

https://www.freeconvert.com/png-to-svg/

flutter packages pub run build_runner build --delete-conflicting-outputs

-- Native Splash
dart run flutter_native_splash:create

--- Asset Scanner
dart run build_runner build --delete-conflicting-outputs

--Rename
flutter pub global activate rename
rename setAppName --targets ios,android --value "Parking Ticket"
rename setBundleId --targets android --value "com.ganpatitechnologies.parkingticket"


*Parking Ticket For UP32KS4180*
BKT Parking
Uttar Pradesh Lucknow
Mob : 9616205455


adb shell am start -a android.intent.action.VIEW -d "app://parkingticket.in/"
adb shell am start -a android.intent.action.VIEW -d "https://ganpatitechnologies.com/"
adb shell am start -a android.intent.action.VIEW -d "https://ganpatitechnologies.com/parking/abc"  com.ganpatitechnologies.parkingticket


keytool -list -v -keystore E:/Kuldeep/Kuldeep/flutter_projects/vparking_app/vParking_keystore_upload.jks

adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://ganpatitechnologies.com/parking/" com.ganpatitechnologies.parkingticket
adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://ganpatitechnologies.com/" com.ganpatitechnologies.parkingticket



show to send and file via Bluetooth in flutter app ?
https://chatgpt.com/share/67874e3e-8d48-800b-bc74-cc5021e5ce67


ALTER DATABASE vparkingapp_zsquare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;



 */
