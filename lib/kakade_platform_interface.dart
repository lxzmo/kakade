import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kakade_method_channel.dart';

abstract class KakadePlatform extends PlatformInterface {
  /// Constructs a KakadePlatform.
  KakadePlatform() : super(token: _token);

  static final Object _token = Object();

  static KakadePlatform _instance = MethodChannelKakade();

  /// The default instance of [KakadePlatform] to use.
  ///
  /// Defaults to [MethodChannelKakade].
  static KakadePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KakadePlatform] when
  /// they register themselves.
  static set instance(KakadePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
