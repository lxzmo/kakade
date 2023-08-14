import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kakade_platform_interface.dart';

/// An implementation of [KakadePlatform] that uses method channels.
class MethodChannelKakade extends KakadePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kakade');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
