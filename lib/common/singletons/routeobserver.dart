// ignore_for_file: avoid_print

import 'dart:developer' as dev;

import 'package:flutter/material.dart';

/// How to use it.
///
/// ```dart
/// MaterialApp(
/// ...
///   navigatorKey: RouteObserverService.navigatorKey,
///   navigatorObservers: [
///     RouteObserverService.instance,
///   ],
/// ...
/// ),
/// ```

class RouteObserverService extends NavigatorObserver {
  RouteObserverService._();

  static final RouteObserverService _instance = RouteObserverService._();

  static RouteObserverService get instance => _instance;

  static final RouteObserver<ModalRoute<void>> modalRouteObserver =
      RouteObserver<ModalRoute<void>>();

  static void subscribeRouteAware(RouteAware routeaware, BuildContext context) {
    modalRouteObserver.subscribe(routeaware, ModalRoute.of(context)!);
  }

  static void unsubscribeRouteAware(RouteAware routeaware) {
    modalRouteObserver.unsubscribe(routeaware);
  }

  static final List<Route<dynamic>> _routeStack = [];

  static Iterable<Route<dynamic>> get routeStack => [..._routeStack];

  void _addRoute(Route<dynamic>? route) {
    if (route != null) {
      _routeStack.add(route);
    }
  }

  void _removeRoute(Route<dynamic>? route) {
    if (route != null) {
      _routeStack.remove(route);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _addRoute(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _removeRoute(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _removeRoute(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _removeRoute(oldRoute);
    _addRoute(newRoute);

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  // String get _current => "current:${_routeStack.map((e) => e.settings.name ?? "/").join(",")}";

  static Route<dynamic>? getRouteByName(String name) {
    for (var route in _routeStack.reversed) {
      if (route.settings.name == name) {
        return route;
      }
    }

    return null;
  }

  static List<Route<dynamic>> getRoutesByName(String name) {
    final routes = <Route<dynamic>>[];
    for (var route in _routeStack.reversed) {
      if (route.settings.name == name) {
        routes.add(route);
      }
    }

    return routes;
  }

  static bool isCurrentRoute(String roteName) {
    for (var e in _routeStack) {
      if (e.settings.name == roteName) {
        return true;
      }
    }

    return false;
  }

  static bool isAnyCurrentRoute(List<String> roteNames) {
    if (_routeStack.isNotEmpty) {
      return roteNames.contains(_routeStack.last.settings.name);
    }
    return false;
  }

  static void printRouteStack() {
    dev.log(_routeStack.map((e) => e.settings.name).toList().toString());
  }

  static bool isRouteInTree(String routeName) {
    return _routeStack.any((e) => e.settings.name == routeName);
  }

  static bool get canPopRoute => _routeStack.length > 1;
}
