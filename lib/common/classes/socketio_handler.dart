import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_billing/common/abstract_classes/initialized_class.dart';
import 'package:pos_billing/common/classes/socket_heartbeet.dart';
import 'package:pos_billing/common/data_source/cache/salereceipt_info_cache_data.dart';
import 'package:pos_billing/common/data_source/cache/workstaff_cache_data.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/basic/socket_response_model.dart';
import 'package:pos_billing/common/models/basic/user_details_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/config/enums/api_progess.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/string_encryter.dart';
import 'package:pos_billing/features/login/login_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

class SocketIoHandler implements InitializedClass, DisposeClass {
  final UserDetails userInfo;
  final SiteDetail siteInfo;

  SocketIoHandler({required this.userInfo, required this.siteInfo}) {
    _socket = io.io(SoketEvents.sokethost, _getOketOptions());
    socketlisten();
  }

  static SocketIoHandler? currentSocket;

  static SocketIoHandler getCurrentUserSoket() {
    currentSocket ??= SocketIoHandler._forCurrentUser();

    return currentSocket!;
  }

  static void removeCurrentSoket() {
    try {
      App.isSocketConnected.value = false;
      currentSocket?.dispose();
      currentSocket = null;
    } catch (e) {
      "removeCurrentSoket : $e".developerLog();
      return;
    }
  }

  // @protected
  factory SocketIoHandler._forCurrentUser() {
    final login = LoginUtil.instance;
    return SocketIoHandler(
      userInfo: login.userNotifier.value,
      siteInfo: login.standDetailsNotifier.value,
    )..registerInternetCallback();
  }

  static Future<SocketResponse> emitWithResponseForCurrentUser(
    String event,
    dynamic data, {
    int timeOutSec = 60,
    ValueChanged<ApiProgessStatus?>? progessStatus,
  }) async {
    return (await currentSocket?.emitWithResponse(
          event,
          data,
          timeOutSec: timeOutSec,
          progessStatus: progessStatus,
        )) ??
        SocketResponse(
          event: event,
          soketStatus: SoketStatus.notConnected,
          resultMessage: "Server not connected.",
        );
  }

  static ValueNotifier<bool> get isSocketConnected => App.isSocketConnected;

  PackageDeviceInfo get _device => DevicePackageDetails.instance.details.value;

  late final SocketHeartbeet _heartbeet = SocketHeartbeet(socket: _socket);

  Completer<bool>? _connectAndGetMasterCompleter;
  Completer<bool>? _connectCompleter;

  final login = LoginUtil.instance;

  // /// It is used to avoid onconnect call on reconnect socket.
  // int _connectcount = 0;

  ValueNotifier<List<String>> onlineUsersNotifier = ValueNotifier<List<String>>(
    [],
  );

  Map<String, dynamic> _getUserInfo() {
    final t0 = DateTime.now();
    return {
      "type": "user",
      "siteId": siteInfo.siteId,
      "siteName": siteInfo.siteName,
      "roleId": userInfo.role.id,
      "roleName": userInfo.role.lable,
      "userId": userInfo.userId,
      "userFullName": userInfo.userFullName,
      "appBuildNumber": _device.buildNumber,
      "deviceType": _device.deviceType,
      "deviceUID": _device.deviceUID,
      "deviceTitle": _device.deviceTitle,
      "deviceLocalTime": t0.dateTimeStanderedFormat,
      "deviceTimeZone": "${t0.timeZoneName}(${t0.timeZoneOffset.inMinutes})",
      "deviceINDTime": t0.toINDDateTime.dateTimeStanderedFormat,
      "isMasterUser": login.isMasteruser,
    };
  }

  Map<String, dynamic> _getOketOptions() {
    final t0 = DateTime.now();
    return OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(1000)
        .setReconnectionDelay(4000)
        .setReconnectionDelayMax(5000)
        .setAuth({
          "appBuildNumber": _device.buildNumber,
          "token": encryptStringV1(jsonEncode(_getUserInfo())),
        })
        .setExtraHeaders({"Content-Type": "application/json"})
        .build();
  }

  late io.Socket _socket;

  bool get isConnected => _socket.connected && App.isSocketConnected.value;
  bool _isDisposed = false;
  String get socketId => _socket.id ?? "";
  String get socketURI => _socket.io.uri;

  @protected
  StreamController<SocketResponse> socketStreamCtrl =
      StreamController<SocketResponse>.broadcast();

  Stream<SocketResponse> get soketStream => socketStreamCtrl.stream;

  void soketEventWithBackResponse(
    String event, {
    Future<dynamic> Function(dynamic data)? callback,
  }) {
    _socket.on(event, (data) async {
      final resp = await callback?.call(data);
      _socket.emit("${event}_ack", resp);
    });
  }

  void emit(String event, {dynamic data}) {
    if (!isConnected) {
      return;
    }
    _socket.emit(event, data);
  }

  Future<SocketResponse> emitWithResponse(
    String event,
    dynamic data, {
    int timeOutSec = 60,
    ValueChanged<ApiProgessStatus?>? progessStatus,
  }) async {
    Completer<SocketResponse> emitCompleter = Completer<SocketResponse>();

    "emitWithResponse $event \n, $data  isConnected : ${_socket.connected}"
        .developerLog("emitWithResponse");

    SocketResponse response = SocketResponse(event: event);

    if (!_socket.connected) {
      return response
        ..resultMessage = "Soket not connected"
        ..soketStatus = SoketStatus.notConnected;
    }
    progessStatus?.call(ApiProgessStatus.sending);

    final t0 = DateTime.now();
    _socket.emitWithAck(
      event,
      data,
      ack: (resp) {
        response = SocketResponse.fetchWithEvent(
          event,
          _tryDecodeSoketData(resp),
          socketPing: DateTime.now().difference(t0).inMilliseconds,
        );

        "response ping: ${response.ping} :: $event".developerLog(
          "emitWithResponse",
        );
        // "emitWithResponse response: $resp".developerLog("emitWithResponse");
        progessStatus?.call(ApiProgessStatus.receiving);
        emitCompleter.complete(response);
      },
    );

    _heartbeet.resetHeartBeet();

    try {
      progessStatus?.call(ApiProgessStatus.waiting);
      return await emitCompleter.future.timeout(Duration(seconds: timeOutSec));
    } on TimeoutException {
      progessStatus?.call(ApiProgessStatus.none);
      return response
        ..resultMessage = "Request timeout !"
        ..soketStatus = SoketStatus.timeout
        ..ping = DateTime.now().difference(t0).inMilliseconds;
    } catch (e) {
      progessStatus?.call(ApiProgessStatus.none);
      return response
        ..resultMessage = "Something was wrong !"
        ..soketStatus = SoketStatus.error
        ..ping = DateTime.now().difference(t0).inMilliseconds;
    }
  }

  Future<SocketResponseV2> emitWithResponseWithoutEncodedDecode(
    String event,
    dynamic data, {
    int timeOutSec = 20,
  }) async {
    Completer<SocketResponseV2> emitCompleter = Completer<SocketResponseV2>();

    SocketResponseV2 response = SocketResponseV2(event: event);

    if (!isConnected) {
      return response..soketStatus = SoketStatus.notConnected;
    }

    _socket.emitWithAck(
      event,
      data,
      ack: (data) {
        response.soketData = data;

        emitCompleter.complete(response);
      },
    );

    try {
      final result = await emitCompleter.future.timeout(
        Duration(seconds: timeOutSec),
        onTimeout: () async {
          return response;
        },
      );
      return result;
    } on TimeoutException {
      return response..soketStatus = SoketStatus.timeout;
    } catch (e) {
      return response..soketStatus = SoketStatus.error;
    }
  }

  void emitEvent(String event, dynamic data) {
    if (!isConnected) {
      return;
    }
    _socket.emit(event, data);
  }

  Future<bool> connectAndWatForMasterData() async {
    if (isConnected) return true;
    try {
      _connectAndGetMasterCompleter = Completer<bool>();

      connectToSoket();
      return await _connectAndGetMasterCompleter?.future.timeout(
            const Duration(minutes: 3),
          ) ??
          false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> connectToSoket() async {
    try {
      if (_socket.connected) return true;

      _connectCompleter = Completer<bool>();
      _socket.connect();
      // int i = 0;
      // while (!_socket.connected && i < 100) {
      //   await Future.delayed(const Duration(milliseconds: 10));
      //   i++;
      // }
      return (_connectCompleter?.future.timeout(
            const Duration(seconds: 60),
            onTimeout: () => false,
          )) ??
          false;
    } catch (e) {
      soketLog("connectToSoket : $e");
      return false;
    }
  }

  void addSteam(SocketResponse data) {
    socketStreamCtrl.add(data);
  }

  dynamic _tryDecodeSoketData(dynamic data) {
    if (data is String && data.isNotEmpty) {
      try {
        var out = jsonDecode(data);
        return out;
      } catch (e) {
        return data;
      }
    }
    return data;
  }

  void _updateSoketConnectionStatus([bool? status]) {
    App.isSocketConnected.value = status ?? _socket.connected;
  }

  void debounceSoketEvent({
    required String event,
    int milliseconds = 1200,
    required VoidCallback onExecute,
    bool callNow = false,
  }) {
    final tag = "event#$event";
    if (callNow) {
      EasyDebounce.cancel(tag);
      onExecute();
    } else {
      EasyDebounce.debounce(tag, const Duration(milliseconds: 1200), () {
        onExecute();
      });
    }
  }

  void _completeGetMasterCompleter(bool status) {
    if (!(_connectAndGetMasterCompleter?.isCompleted ?? false)) {
      _connectAndGetMasterCompleter?.complete(status);
    }
  }

  void _completeConnectCompleter(bool status) {
    if (!(_connectCompleter?.isCompleted ?? false)) {
      _connectCompleter?.complete(status);
    }
  }

  void onUpdateOnlineStandUsers(SocketResponse resp) {
    if (resp.soketData is List<dynamic>) {
      onlineUsersNotifier.value = List<String>.from(resp.soketData);
    }
  }

  void onAnySoketEvent(String event, dynamic data) async {
    try {
      if (kDebugMode) {
        soketLog("event : $event");
        // soketLog((event, data));
      }

      dynamic decoded = _tryDecodeSoketData(data);

      final soketResp = SocketResponse.fetchWithEvent(event, decoded);

      addSteam(soketResp);
    } catch (e) {
      return;
    }

    _heartbeet.resetHeartBeet();
  }

  void _onSoketConnect(dynamic data) {
    soketLog('connected : $data');

    _completeConnectCompleter(true);
    _updateSoketConnectionStatus();
    ItemInfoCacheData.instance.getItemsInfo(force: true);
    _heartbeet.resetHeartBeet();
    SalereceiptInfoCacheData.instance.syncLocalData();
  }

  void _onConnectError(dynamic data) {
    soketLog("onConnectError $data \n$socketURI");
    _updateSoketConnectionStatus();
    _completeGetMasterCompleter(false);
    _completeConnectCompleter(false);
    _heartbeet.stop();
  }

  void _onDisconnect(dynamic data) {
    soketLog('disconnect : $data');
    _updateSoketConnectionStatus();
    _heartbeet.stop();
  }

  void onUserLogOut(dynamic data) async {
    if (!login.isLoggedIn) {
      return;
    }
    login.makeUserLogout(false);
    App.pushAndRemoveAll(
      (_) => LoginScreen(),
      routeName: LoginScreen.routeName,
    );
    "You are loged in from another device !".showToast;
    await Future.delayed(Duration(seconds: 1));
    removeCurrentSoket();
  }

  void socketlisten() {
    _socket.onAny(onAnySoketEvent);

    _socket.onDisconnect(_onDisconnect);
    _socket.on(SoketEvents.logoutUser, onUserLogOut);
    _socket.onConnect(_onSoketConnect);
    _socket.onConnectError(_onConnectError);
  }

  @protected
  void soketLog(dynamic data) {
    dev.log("$data", name: "SocketIoHandler");
  }

  @protected
  void registerInternetCallback() {
    InternetConnectivity.registerChangeCallBacks(
      tag: "soketIO",
      onChange: (status) {
        if (_isDisposed) return;
        EasyDebounce.debounce(
          'SoketIOInternet',
          const Duration(seconds: 2),
          () {
            if (status) {
              _socket.connect();
            } else {
              _socket.disconnect();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _socket.disconnect();
    _socket.dispose();
    socketStreamCtrl.close();
    _heartbeet.dispose();
    InternetConnectivity.removeChangeCallBacks(tag: "soketIO");
  }

  bool _isInitialized = false;

  @override
  FutureOr<void> initialized() async {
    if (_isInitialized) return;
    _isInitialized = true;
    soketLog("initialized call");

    // _socket.connect();
    await connectToSoket();
  }
}
