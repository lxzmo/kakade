import AlicomFusionAuth
import Flutter
import MBProgressHUD
import UIKit

public class SwiftKakadePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "kakade", binaryMessenger: registrar.messenger())
    let instance = SwiftKakadePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getSDKVersion":
       getSDKVersion(result: result)
    case "init":

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func getSDKVersion(result: @escaping FlutterResult) {
    let version = AlicomFusionAuthHandler.getSDKVersion()
    result("阿里云融合认证版本:\(version)")
  }
}
