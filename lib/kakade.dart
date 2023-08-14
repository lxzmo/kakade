import 'package:flutter/services.dart';

class Kakade {
  static const MethodChannel _methodChannel = MethodChannel('kakade');

  static Future<String?> getPlatformVersion() {
    return _methodChannel.invokeMethod('getPlatformVersion');
  }

  static Future<String?> getSDKVersion() {
    return _methodChannel.invokeMethod('getSDKVersion');
  }
}
