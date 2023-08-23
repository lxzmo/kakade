import 'dart:async';

import 'package:flutter/services.dart';

import '../kakade.dart';

class Kakade {
  static const MethodChannel _methodChannel = MethodChannel('kakade');

  // 获取平台版本
  static Future<String?> getPlatformVersion() {
    return _methodChannel.invokeMethod('getPlatformVersion');
  }

  // 获取SDK版本
  static Future<String?> getSDKVersion() {
    return _methodChannel.invokeMethod('getSDKVersion');
  }

  // 初始化
  static Future<String?> initSdk({required AuthConfig authConfig}) {
    return _methodChannel.invokeMethod(
      'initSdk',
      authConfig.toJson(),
    );
  }

  // 更新手机号
  static void updatePhoneNumber({required String number}) {
    _methodChannel.invokeMethod('updatePhoneNumber', number);
  }

  // 销毁服务
  static void destroy() {
    _methodChannel.invokeMethod('destroy');
  }

  // SDK回调
  static void sdkCallback({onSdkCallbackEvent, updateToken}) {
    _methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onSdkCallbackEvent':
          final AuthResponseModel responseModel = AuthResponseModel.fromJson(
            Map.from(call.arguments),
          );
          await onSdkCallbackEvent(responseModel);
          break;
        case 'onSDKTokenUpdate':
          // 获取新Token
          return await updateToken();
        default:
          throw UnsupportedError('Unrecognized JSON message');
      }
    });
  }

  // 登录注册场景
  static void loginRegister() {
    _methodChannel.invokeMethod('loginRegister');
  }

  // 更换手机号场景
  static void changeMobile() {
    _methodChannel.invokeMethod('changeMobile');
  }

  // 重置密码场景
  static void resetPassword() {
    _methodChannel.invokeMethod('resetPassword');
  }

  // 绑定新手机号场景
  static void bindNewMobile() {
    _methodChannel.invokeMethod('bindNewMobile');
  }

  // 验证绑定手机号场景
  static void verifyBindMobile() {
    _methodChannel.invokeMethod('verifyBindMobile');
  }
}
