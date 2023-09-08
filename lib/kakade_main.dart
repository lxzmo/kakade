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
  static Future<bool?> initSdk({required AuthConfig authConfig}) async {
    return await _methodChannel.invokeMethod(
      'initSdk',
      authConfig.toJson(),
    );
  }

  // 更新手机号
  static void updatePhoneNumber(String number) {
    _methodChannel.invokeMethod('updatePhoneNumber', number);
  }

  // 销毁服务
  static void destroy() {
    _methodChannel.invokeMethod('destroy');
  }

  // SDK回调
  static void sdkCallback(
      {onSDKTokenAuthSuccess,
      onSDKTokenUpdate,
      onSDKTokenAuthFailure,
      onVerifySuccess,
      onHalfwayVerifySuccess,
      onVerifyFailed,
      onTemplateFinish,
      onGetPhoneNumber,
      onProtocolClick,
      onVerifyInterrupt,
      onAuthEvent}) {
    _methodChannel.setMethodCallHandler((call) async {
      final AuthResponseModel responseModel = AuthResponseModel.fromJson(
        Map.from(call.arguments),
      );
      switch (call.method) {
        case 'onSDKTokenAuthSuccess':
          // token鉴权成功
          await onSDKTokenAuthSuccess();
          break;
        case 'onSDKTokenUpdate':
          // 获取新Token
          return await onSDKTokenUpdate();
        case 'onSDKTokenAuthFailure':
          // token鉴权失败
          await onSDKTokenAuthFailure(responseModel);
          break;
        case 'onVerifySuccess':
          // 认证成功
          onVerifySuccess(responseModel);
          break;
        case 'onHalfwayVerifySuccess':
          // 中途认证节点
          onHalfwayVerifySuccess(responseModel);
          break;
        case 'onVerifyFailed':
          // 认证失败
          onVerifyFailed(responseModel);
          break;
        case 'onTemplateFinish':
          // 场景流程结束
          onTemplateFinish(responseModel);
          break;
        case 'onGetPhoneNumber':
          // 填充手机号
          return onGetPhoneNumber();
        case 'onProtocolClick':
          // 点击协议富文本
          onProtocolClick(responseModel);
          break;
        case 'onVerifyInterrupt':
          // 认证中断
          onVerifyInterrupt(responseModel);
          break;
        case 'onAuthEvent':
          // 场景事件回调
          onAuthEvent(responseModel);
          break;
        default:
          throw UnsupportedError('Unrecognized JSON message');
      }
    });
  }

  // 开始拉起场景
  static void startScene() {
    _methodChannel.invokeMethod('startScene');
  }

  // 继续场景
  static void continueScene(bool isAuthSuccess) {
    _methodChannel.invokeMethod('continueScene', isAuthSuccess);
  }

  // 结束场景
  static void stopScene() {
    _methodChannel.invokeMethod('stopScene');
  }
}
