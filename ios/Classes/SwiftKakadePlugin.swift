#if targetEnvironment(simulator) 
#else
import AlicomFusionAuth
#endif
import Flutter
import MBProgressHUD
import UIKit
import Foundation

public class SwiftKakadePlugin: NSObject, FlutterPlugin{
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

    // 当前场景ID
    var currentTemplatedId: String = "100001"

    // 当前手机号
    var phoneNumber: String = ""

    var viewController : FlutterViewController?

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
        // instance.httpAuthority()
        guard let flutterViewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController else {
            return
        }

        // 设置全屏模式
        flutterViewController.modalPresentationStyle = .fullScreen
        instance.viewController = flutterViewController
        #endif
    }

    // 处理方法
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getPlatformVersion":
                // 获取平台版本
                result("iOS " + UIDevice.current.systemVersion)
            case "getSDKVersion":
                // 获取SDK版本
                #if targetEnvironment(simulator)
                result(FlutterError(code: "100000", message: "不支持模拟器架构", details: nil))
                #else
                getSDKVersion(result: result)
                #endif
            case "initSdk":
                // 初始化SDK
                #if targetEnvironment(simulator)
                result(FlutterError(code: "100000", message: "不支持模拟器架构", details: nil))
                #else
                initSdk(arguments: call.arguments, result: result)
                #endif
            #if targetEnvironment(simulator)
            #else
            case "startScene":
                // 开始拉起场景
                startScene(result: result)
            case "continueScene":
                // 继续场景
                continueScene(arguments: call.arguments, result: result)
            case "updatePhoneNumber":
                // 更新手机号
                updatePhoneNumber(arguments: call.arguments, result: result)
             case "stopScene":
                // 结束场景
                stopScene()
            case "destroy":
                // 销毁服务
                destroy()
            #endif
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    #if targetEnvironment(simulator) 
    #else

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

    // 获取SDK版本
    public func getSDKVersion(result: @escaping FlutterResult) {
        let version = AlicomFusionAuthHandler.getSDKVersion()
        result("阿里云融合认证版本:\(version)")
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
        if let enableLog: Bool = params["enableLog"] as? Bool {
            // 设置是否打印日志
            AlicomFusionLog.logEnable(enableLog ?? false)
        }
        if let currentTemplatedId: String = params["currentTemplatedId"] as? String {
            // 设置当前场景ID
            self.currentTemplatedId = currentTemplatedId
        }
        // 设置参数
        authConfig = AuthConfig(params: params)
        let token = AlicomFusionAuthToken(tokenStr:tokenStr)
        handler = AlicomFusionAuthHandler(token: token, schemeCode: schemeCode)
        handler?.setFusionAuthDelegate(delegate!)
        result(true)
    }

    // 开始拉起场景
    public func startScene(result: @escaping FlutterResult){
        // guard let viewController = WindowUtils.getCurrentViewController() else {
        //     result(FlutterError(code: AlicomFusionTokenVerifyFail, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
        //     return
        // }
        // handler?.startScene(withTemplateId: currentTemplatedId, viewController: self.viewController!)

        handler?.startSceneUI(withTemplateId: currentTemplatedId, viewController:  self.viewController!,delegate:uiDelegate!)
    }

    // 继续场景
    public func continueScene(arguments: Any?, result: @escaping FlutterResult){
        let isSuccess: Bool = arguments as? Bool ?? false
        handler?.continueScene(withTemplateId: currentTemplatedId,isSuccess: isSuccess)
    }

    // 更新认证后返回的手机号
    public func updatePhoneNumber(arguments: Any?, result: @escaping FlutterResult){
        let number: String = arguments as? String ?? ""
        self.phoneNumber = number;
        print("kakadephoneNumber \(phoneNumber)")
    }

    // 更新Token
    public func updateSDKToken(completion: @escaping (String) -> Void) {
        methodChannel?.invokeMethod("onSDKTokenUpdate", arguments: nil) { result in
            if let newTokenStr = result as? String {
                completion(newTokenStr)
            }
        }
    }

    // 结束场景
    public func stopScene(){
        handler?.stopScene(withTemplateId: currentTemplatedId)
    }

    // 销毁服务
    public func destroy() {
        handler?.destroy();
        handler = nil;
    }
    #endif
}