import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/dialogues/show_no_internet.dart';
import 'package:pos_billing/common/singletons/app.dart';

class InternetConnectivity extends StatefulUtil {
  InternetConnectivity._();

  static final InternetConnectivity _instance = InternetConnectivity._();

  static InternetConnectivity get instance => _instance;

  static ValueNotifier<bool> availableNotifier = ValueNotifier<bool>(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  static final Map<String, ValueChanged<bool>> _changeCallBacks = {};

  static bool _status = true;

  static final List<ConnectivityResult> _positiveResults = [
    ConnectivityResult.ethernet,
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
    // ConnectivityResult.vpn,
  ];

  static bool get available => _status;
  static bool get notAvailable => !_status;

  /// This will return [true] if internet not available and how dialogue
  static bool checkNotAvailableAndShowDialogue() {
    if (notAvailable) {
      showNoInternetAvailable();
    }
    return notAvailable;
  }

  void _onStatusChange() {
    // if (_status) {
    //   EasyDebounce.debounce(
    //     "_onStatusChangeChangeSyncData",
    //     const Duration(seconds: 3),
    //     () {
    //       SyncLocalData.instance.syncOfflineData();
    //     },
    //   );
    // }

    for (var event in _changeCallBacks.entries) {
      event.value.call(_status);
    }
  }

  static void registerChangeCallBacks({
    required String tag,
    required ValueChanged<bool> onChange,
  }) {
    if (App.isNotMobileDevice) return;
    _changeCallBacks[tag] = onChange;
  }

  static void removeChangeCallBacks({required String tag}) {
    if (App.isNotMobileDevice) return;
    _changeCallBacks.remove(tag);
  }

  static Future<void> forceSetStatus() async {
    if (App.isNotMobileDevice) return;
    final result = await Connectivity().checkConnectivity();
    _status = result.any((e) => _positiveResults.contains(e));
    availableNotifier.value = _status;
  }

  @override
  void onPageClose() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void onPageInit() {
    if (App.isNotMobileDevice) return;
    _subscription ??= Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      _status = false;
      for (var x in result) {
        if (_positiveResults.contains(x)) {
          _status = true;
          break;
        }
      }

      availableNotifier.value = _status;
      _onStatusChange();
    });
  }

  // You can replace this method from any other method.
  static Future<String> getIpAddress() async {
    try {
      String? tun0; // 1-Priority
      String? wlan0; // 2-Priority
      String? other; // 3-Priority

      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: true,
      );

      for (var interface in interfaces) {
        if (interface.addresses.isNotEmpty) {
          final address = interface.addresses[0].address;
          if (interface.name == "tun0") {
            tun0 = address;
          } else if (interface.name == "wlan0") {
            wlan0 = address;
          } else {
            other = address;
          }
        }
      }
      return tun0 ?? wlan0 ?? other ?? "";
    } catch (e) {
      return "";
    }
  }
}
