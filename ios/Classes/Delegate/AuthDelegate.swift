#if targetEnvironment(simulator)   
#else
import AlicomFusionAuth
import Foundation

class AuthDelegate: NSObject, AlicomFusionAuthDelegate{
    private let flutterChannel: FlutterMethodChannel?

    let swiftKakadePlugin = SwiftKakadePlugin();
    
    init(flutterChannel: FlutterMethodChannel) {
        self.flutterChannel = flutterChannel
        super.init()
    }

    // token需要更新
    func onSDKTokenUpdate(_ handler: AlicomFusionAuthHandler) -> AlicomFusionAuthToken {
        var newTokenStr: String = ""
        swiftKakadePlugin.updateSDKToken { tokenStr in
            newTokenStr = tokenStr
            let token = AlicomFusionAuthToken(tokenStr: newTokenStr)
            handler.update(token)
        }
        return AlicomFusionAuthToken(tokenStr: "placeholder_token")
    }

    // token鉴权成功
    func onSDKTokenAuthSuccess(_ handler: AlicomFusionAuthHandler) {
        swiftKakadePlugin.isActive = true;
        print("kakadeCallback Token鉴权成功")
    }

    // token鉴权失败
    func onSDKTokenAuthFailure(_ handler: AlicomFusionAuthHandler, fail: AlicomFusionAuthToken, error: AlicomFusionEvent) {
        swiftKakadePlugin.isActive = false;
        print("kakadeCallback Token鉴权失败")
    }

    // 认证成功
    func onVerifySuccess(_ handler: AlicomFusionAuthHandler, nodeName: String, maskToken: String, event: AlicomFusionEvent) {
        print("kakadeCallback 认证成功: \(maskToken)")
    }

    // 中途认证节点
    func onHalfwayVerifySuccess(_ handler: AlicomFusionAuthHandler, nodeName: String, maskToken: String, event: AlicomFusionEvent, resultBlock: @escaping (Bool) -> Void) {
        // 实现中途认证成功的逻辑
        // 调用resultBlock(true)以继续，调用resultBlock(false)以停止
        print("kakade 中途认证节点")
    }

    // 认证失败
    func onVerifyFailed(_ handler: AlicomFusionAuthHandler, nodeName: String, error: AlicomFusionEvent) {
        // 实现认证失败的逻辑
        print("kakadeCallback 认证失败")
    }

    // 场景流程结束
    func onTemplateFinish(_ handler: AlicomFusionAuthHandler, event: AlicomFusionEvent) {
        // 实现场景流程结束的逻辑
        print("kakadeCallback 场景流程结束")
    }

    // 填充手机号
    func onGetPhoneNumber(forVerification handler: AlicomFusionAuthHandler, event: AlicomFusionEvent) -> String {
        // 实现获取用于验证的手机号逻辑
        return swiftKakadePlugin.phoneNumber
    }  

    // 点击协议富文本
    func onProtocolClick(_ handler: AlicomFusionAuthHandler, protocolName: String, protocolUrl: String, event: AlicomFusionEvent) {
        // 实现协议点击的逻辑
    }

    // 认证中断
    func onVerifyInterrupt(_ handler: AlicomFusionAuthHandler, event: AlicomFusionEvent) {
        // 实现认证中断的逻辑
        print("kakadeCallback 认证中断")
    }

    // 场景事件回调
    func onAuthEvent(_ handler: AlicomFusionAuthHandler, eventData: AlicomFusionEvent) {
        // 可以在此处执行相应的处理逻辑，例如发送Flutter通知，更新界面等
        // 请注意：由于这里在Swift中，可能需要将事件信息传递给Flutter端
        // 以便Flutter端能够适当地处理认证事件
        print("收到认证事件：\(eventData)")
        let eventDictionary: [String: Any] = [
            "templateId": eventData.templateId ,
            "nodeId": eventData.nodeId ,
            "resultCode": eventData.resultCode,
            "resultMsg": eventData.resultMsg ,
            "innerCode": eventData.innerCode ,
            "innerMsg": eventData.innerMsg ,
            "carrierFailedResultData": eventData.carrierFailedResultData ,
            "innerRequestId": eventData.innerRequestId ,
            "requestId": eventData.requestId ,
            "extendData": eventData.extendData,
        ]
        let responseModel = ResponseModel(eventDictionary)
        flutterChannel?.invokeMethod(SwiftKakadePlugin.CALLBACK_EVENT, arguments: responseModel.json)
    }
}
#endif