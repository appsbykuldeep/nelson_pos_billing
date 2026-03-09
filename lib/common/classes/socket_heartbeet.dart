import 'dart:async';

import 'package:pos_billing/common/abstract_classes/initialized_class.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketHeartbeet implements InitializedClass, DisposeClass {
  io.Socket socket;

  SocketHeartbeet({required this.socket});

  Timer? _timer;

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void resetHeartBeet() {
    stop();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _beet();
    });
  }

  void _beet() {
    try {
      if (socket.connected) {
        socket.emit("Heartbeet");
        "SocketHeartbeet".developerLog();
      }
    } catch (e) {
      e.toString().developerLog();
    }
  }

  @override
  FutureOr<void> dispose() {
    stop();
  }

  @override
  FutureOr<void> initialized() {
    resetHeartBeet();
  }
}
