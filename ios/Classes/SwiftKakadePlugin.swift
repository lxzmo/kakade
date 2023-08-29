#if targetEnvironment(simulator) 
#else
import AlicomFusionAuth
#endif
import Flutter
import MBProgressHUD
import UIKit
import Foundation

public class SwiftKakadePlugin: NSObject, FlutterPlugin{
    // SDK回调事件
    static var CALLBACK_EVENT: String = "onSdkCallbackEvent"

    // 通道
    var methodChannel: FlutterMethodChannel?

    #if targetEnvironment(simulator)
    #else

    let authUIBuilder: AuthUIBuilder = .init()

    var authConfig: AuthConfig?
    
    // 实例
    var handler: AlicomFusionAuthHandler?
    
     // 代理
    var delegate: AuthDelegate?
    var uiDelegate: AuthUIDelegate?
    #endif

    // 是否鉴权成功
    var isActive: Bool = false {
        didSet {
            if isActive && isActive != oldValue {
                print("kakade Token鉴权成功")
            }
        }
    }

    // 当前手机号
    var phoneNumber: String = ""

    // 注册插件
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "kakade", binaryMessenger: registrar.messenger())
        let instance: SwiftKakadePlugin = SwiftKakadePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.methodChannel = channel
        #if targetEnvironment(simulator)
        #else
        instance.authUIBuilder.register = registrar
        // 设置代理
        instance.delegate = AuthDelegate(flutterChannel: channel,instance: instance)
        instance.uiDelegate = AuthUIDelegate(instance: instance)
        // 验证网络是否可用
        instance.httpAuthority()
        #endif
    }

    // 处理方法
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initSdk":
                // 初始化SDK
                #if targetEnvironment(simulator)
                result(FlutterError(code: "100000", message: "不支持模拟器架构", details: nil))
                #else
                initSdk(arguments: call.arguments, result: result)
                #endif
            case "getSDKVersion":
                // 获取SDK版本
                #if targetEnvironment(simulator)
                result(FlutterError(code: "100000", message: "不支持模拟器架构", details: nil))
                #else
                getSDKVersion(result: result)
                #endif
            #if targetEnvironment(simulator)
            #else
            case "getPlatformVersion":
                // 获取平台版本
                result("iOS " + UIDevice.current.systemVersion)
            case "updatePhoneNumber":
                // 更新手机号
                updatePhoneNumber(arguments: call.arguments, result: result)
            case "destroy":
                // 销毁服务
                destroy()
            case "loginRegister":
                // 登录注册场景
                loginRegister(result: result)
            case "stopLoginRegisterScene":
                // 结束登录注册
                stopLoginRegisterScene()
            case "changeMobile":
                // 更换手机号场景
                changeMobile(result: result)
            case "resetPassword":
                // 重置密码场景
                resetPassword(result: result)
            case "bindNewMobile":
                // 绑定新手机号场景
                bindNewMobile(result: result)
            case "verifyBindMobile":
                // 验证绑定手机号场景
                verifyBindMobile(result: result)
             #endif
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    #if targetEnvironment(simulator) 
    #else

    // 获取SDK版本
    public func getSDKVersion(result: @escaping FlutterResult) {
        let version = AlicomFusionAuthHandler.getSDKVersion()
        result("阿里云融合认证版本:\(version)")
    }

    // 检查联网
    public func httpAuthority() {
        if let testUrl: URL = URL(string: "https://www.baidu.com") {
        let urlRequest: URLRequest = URLRequest(url: testUrl)
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-type": "application/json"]
        config.timeoutIntervalForRequest = 20
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session: URLSession = URLSession(configuration: config)
        session.dataTask(with: urlRequest) { _, _, error in
            print("KakadePlugin: 联网\(error == nil ? "成功" : "失败")")
            }.resume()
        } else {
            print("KakadePlugin: 联网失败")
            return
        }
    }

    // 销毁服务
    public func destroy() {
        handler?.destroy();
        handler = nil;
        isActive = false;
    }
    
    // 更新认证后返回的手机号
    public func updatePhoneNumber(arguments: Any?, result: @escaping FlutterResult){
        guard let number: String = arguments as? String else {
            // 参数有问题
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "初始化失败，参数不正确：InitConfig不能为空", details: nil))
            return
        }
        phoneNumber = number;
        print("kakade \(phoneNumber)")
    }

    // 更新Token
    public func updateSDKToken(completion: @escaping (String) -> Void) {
        methodChannel?.invokeMethod("onSDKTokenUpdate", arguments: nil) { result in
            if let newTokenStr = result as? String {
                completion(newTokenStr)
            }
        }
    }
    
    // 初始化SDK，传入 tokenStr:鉴权Token ， schemeCode:方案号
    public func initSdk(arguments: Any?, result: @escaping FlutterResult){
        guard let params: [String: Any] = arguments as? [String: Any] else {
            // 参数有问题
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "初始化失败，参数不正确：InitConfig不能为空", details: nil))
            return
        }
        guard let tokenStr: String = params["tokenStr"] as? String else {
            // 没有token
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "初始化失败，参数不正确：iOS的token为空", details: nil))
            return
        }
        guard let schemeCode: String = params["iosSchemeCode"] as? String else {
            // 没有schemeCode
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "初始化失败，参数不正确：iOS的schemeCode为空", details: nil))
            return
        }
        // 设置参数
        authConfig = AuthConfig(params: params)
        let token = AlicomFusionAuthToken(tokenStr:tokenStr)
        handler = AlicomFusionAuthHandler(token: token, schemeCode: schemeCode)
        handler?.setFusionAuthDelegate(delegate!)
    }
    
    // 登录注册场景
    public func loginRegister(result: @escaping FlutterResult){
        guard let viewController = WindowUtils.getCurrentViewController() else {
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }
        handler?.startSceneUI(withTemplateId: AlicomFusionTemplateId_100001, viewController: viewController,delegate:uiDelegate!)
    }

    // 结束 登录注册场景
    public func stopLoginRegisterScene(){
        handler?.stopScene(withTemplateId: AlicomFusionTemplateId_100001)
        destroy()
    }

    // 更换手机号场景
    public func changeMobile(result: @escaping FlutterResult){
        guard let viewController = WindowUtils.getCurrentViewController() else {
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }
        handler?.startScene(withTemplateId: AlicomFusionTemplateId_100002, viewController: viewController)
    }

    // 重置密码场景
    public func resetPassword(result: @escaping FlutterResult){
        guard let viewController = WindowUtils.getCurrentViewController() else {
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }
        handler?.startScene(withTemplateId: AlicomFusionTemplateId_100003, viewController: viewController)
    }

    // 绑定新手机号场景
    public func bindNewMobile(result: @escaping FlutterResult){
        guard let viewController = WindowUtils.getCurrentViewController() else {
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }
        handler?.startScene(withTemplateId: AlicomFusionTemplateId_100004, viewController: viewController)
    }

    // 验证绑定手机号场景
    public func verifyBindMobile(result: @escaping FlutterResult){
        guard let viewController = WindowUtils.getCurrentViewController() else {
            result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }
        handler?.startScene(withTemplateId: AlicomFusionTemplateId_100005, viewController: viewController)
    }
    #endif
}