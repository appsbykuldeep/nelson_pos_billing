import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'move_app_background_method_channel.dart';

abstract class MoveAppBackgroundPlatform extends PlatformInterface {
  /// Constructs a MoveAppBackgroundPlatform.
  MoveAppBackgroundPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoveAppBackgroundPlatform _instance = MethodChannelMoveAppBackground();

  /// The default instance of [MoveAppBackgroundPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoveAppBackground].
  static MoveAppBackgroundPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoveAppBackgroundPlatform] when
  /// they register themselves.
  static set instance(MoveAppBackgroundPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> move() {
    throw UnimplementedError('move() has not been implemented.');
  }
}
