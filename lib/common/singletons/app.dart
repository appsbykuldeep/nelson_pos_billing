import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/routeobserver.dart';
import 'package:pos_billing/config/enums/app_company.dart';

class App {
  App._();

  static bool isMobileDevice =
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool isNotMobileDevice = !isMobileDevice;

  static bool isWindowsDevice = !kIsWeb && Platform.isWindows;
  static bool isDesktopDevice = kIsWeb || Platform.isWindows;

  static const AppCompany company = AppCompany.parkingTicket;

  // static bool automaticallyImplyLeading = !kIsWeb;

  static String platformType = () {
    if (kIsWeb) return "web";
    if (Platform.isWindows) return "windows";
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    return "";
  }();

  static int afterLines = isWindowsDevice ? 5 : 2;

  // static bool useLocalDataSource =
  //     !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static bool get haveContext => navigatorKey.currentState != null;

  static ValueNotifier<bool> isSocketConnected = ValueNotifier(false);

  static bool isFirstTimeOpen = false;

  static BuildContext get context => navigatorKey.currentState!.context;
  static ThemeData get theme => Theme.of(context);
  static Size get size => MediaQuery.sizeOf(context);

  static void opneDrawer(BuildContext context) {
    try {
      Scaffold.of(context).openDrawer();
    } catch (e) {
      return;
    }
  }

  static void closeDrawer(BuildContext context) {
    try {
      Scaffold.of(context).closeDrawer();
    } catch (e) {
      return;
    }
  }

  static String parseRouteNameByBuilder(Widget Function(BuildContext) builder) {
    String routeName = "/${builder.runtimeType}";

    routeName = routeName.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!routeName.startsWith('/')) {
      routeName = '/$routeName';
    }
    return Uri.tryParse(routeName)?.toString() ?? routeName;
  }

  static Future<T?> to<T>(
    Widget Function(BuildContext) builder, {
    RouteSettings? settings,
    required String? routeName,
  }) {
    routeName ??= parseRouteNameByBuilder(builder);
    if (settings == null && routeName.isNotEmpty) {
      settings = RouteSettings(name: routeName);
    }
    return Navigator.of(
      context,
    ).push<T>(MaterialPageRoute(builder: builder, settings: settings));
  }

  static void pop<T>([T? result]) {
    Navigator.of(context).pop(result);
  }

  static void back<T>([T? result]) {
    if (RouteObserverService.canPopRoute) {
      Navigator.of(context).pop(result);
    }
  }

  static void removeRouteByName(String routeName, {dynamic result}) {
    removeRoute(RouteObserverService.getRouteByName(routeName), result: result);
  }

  static void removeAllRouteByName(String routeName) {
    for (var route in RouteObserverService.getRoutesByName(routeName)) {
      removeRoute(route);
    }
  }

  static void removeRoute<T>(Route<dynamic>? route, {dynamic result}) {
    if (route != null) {
      Navigator.removeRoute(context, route, result);
    }
  }

  static Future<T?> pushReplacement<T>(
    Widget Function(BuildContext) builder, {
    RouteSettings? settings,
    String? routeName,
    dynamic result,
  }) {
    if (settings == null && routeName != null && routeName.isNotEmpty) {
      settings = RouteSettings(name: routeName);
    }
    return Navigator.of(context).pushReplacement<T, dynamic>(
      MaterialPageRoute(builder: builder, settings: settings),
      result: result,
    );
  }

  static Future<T?> pushAndRemoveAll<T>(
    Widget Function(BuildContext) builder, {
    RouteSettings? settings,
    required String? routeName,
    dynamic result,
  }) {
    final stacks = RouteObserverService.routeStack;
    final len = stacks.length;
    if (len == 0) {
      return Future.value();
    }

    for (var route in stacks.take(len - 1)) {
      Navigator.removeRoute(context, route);
    }

    if (settings == null && routeName != null && routeName.isNotEmpty) {
      settings = RouteSettings(name: routeName);
    }
    return pushReplacement(builder, settings: settings, result: result);
  }

  static void removeRoutesAfter(String routeName) {
    bool canRemoveNext = false;
    for (var route in RouteObserverService.routeStack) {
      if (canRemoveNext) {
        Navigator.removeRoute(context, route);
        continue;
      }

      if (route.settings.name == routeName) {
        canRemoveNext = true;
      }
    }
  }

  static bool isRouteInTree(String routeName) {
    return RouteObserverService.isRouteInTree(routeName);
  }

  static bool isCurrentRoute(String routeName) {
    return RouteObserverService.isCurrentRoute(routeName);
  }
}
