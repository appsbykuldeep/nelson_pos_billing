import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'move_app_background_platform_interface.dart';

/// An implementation of [MoveAppBackgroundPlatform] that uses method channels.
class MethodChannelMoveAppBackground extends MoveAppBackgroundPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('move_app_background');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> move() async {
    try {
      await methodChannel.invokeMethod<String>('moveAppToBack');
      return true;
    } catch (e) {
      return false;
    }
  }
}
