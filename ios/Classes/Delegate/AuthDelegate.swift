#if targetEnvironment(simulator)   
#else
import AlicomFusionAuth
import Foundation

class AuthDelegate: NSObject, AlicomFusionAuthDelegate{
    private let flutterChannel: FlutterMethodChannel
    private let instance: SwiftKakadePlugin
    
    init(flutterChannel: FlutterMethodChannel,instance: SwiftKakadePlugin) {
        self.flutterChannel = flutterChannel
        self.instance = instance
        super.init()
    }

    // token需要更新
    func onSDKTokenUpdate(_ handler: AlicomFusionAuthHandler) -> AlicomFusionAuthToken {
        var newTokenStr: String = ""
        instance.updateSDKToken { tokenStr in
            newTokenStr = tokenStr
            let token = AlicomFusionAuthToken(tokenStr: newTokenStr)
            handler.update(token)
        }
        return AlicomFusionAuthToken(tokenStr: "placeholder_token")
    }

    // token鉴权成功
    func onSDKTokenAuthSuccess(_ handler: AlicomFusionAuthHandler) {
        print("kakadeCallback Token鉴权成功")
        let responseModel = ResponseModel([
            "resultCode":AlicomFusionTokenValid,
            "resultMsg": "token合法" ,
        ])
        flutterChannel.invokeMethod("onSDKTokenAuthSuccess", arguments: responseModel.json)
    }

    // token鉴权失败
    func onSDKTokenAuthFailure(_ handler: AlicomFusionAuthHandler, fail: AlicomFusionAuthToken, error: AlicomFusionEvent) {
        print("kakadeCallback Token鉴权失败")
        let responseModel = ResponseModel([
            "templateId": error.templateId ,
            "resultCode":error.resultCode,
            "resultMsg": error.resultMsg,
            "innerCode": error.innerCode,
            "innerMsg": error.innerMsg
        ])
        flutterChannel.invokeMethod("onSDKTokenAuthFailure", arguments: responseModel.json)
    }

    // 认证成功
    func onVerifySuccess(_ handler: AlicomFusionAuthHandler, nodeName: String, maskToken: String, event: AlicomFusionEvent) {
        print("kakadeCallback 认证成功: \(maskToken)")
        let responseModel = ResponseModel([
            "templateId": event.templateId ,
            "resultCode": event.resultCode,
            "resultMsg": event.resultMsg ,
            "maskToken": maskToken
        ])
        flutterChannel.invokeMethod("onVerifySuccess", arguments: responseModel.json)
    }

    // 中途认证节点
    func onHalfwayVerifySuccess(_ handler: AlicomFusionAuthHandler, nodeName: String, maskToken: String, event: AlicomFusionEvent, resultBlock: @escaping (Bool) -> Void) {
        // 实现中途认证成功的逻辑
        // 调用resultBlock(true)以继续，调用resultBlock(false)以停止
        print("kakadeCallback 中途认证节点")
    }

    // 认证失败
    func onVerifyFailed(_ handler: AlicomFusionAuthHandler, nodeName: String, error: AlicomFusionEvent) {
        // 实现认证失败的逻辑
        print("kakadeCallback 认证失败")
        let responseModel = ResponseModel([
            "templateId": error.templateId ,
            "resultCode": error.resultCode,
            "resultMsg": error.resultMsg ,
            "innerCode": error.innerCode,
            "innerMsg": error.innerMsg
        ])
        flutterChannel.invokeMethod("onVerifyFailed", arguments: responseModel.json)
    }

    // 场景流程结束
    func onTemplateFinish(_ handler: AlicomFusionAuthHandler, event: AlicomFusionEvent) {
        // 实现场景流程结束的逻辑
        print("kakadeCallback 场景流程结束")
        instance.stopScene()
    }

    // 填充手机号
    func onGetPhoneNumber(forVerification handler: AlicomFusionAuthHandler, event: AlicomFusionEvent) -> String {
        // 实现获取用于验证的手机号逻辑、
        print("kakadeCallback 填充手机号")
        return instance.phoneNumber
    }  

    // 点击协议富文本
    func onProtocolClick(_ handler: AlicomFusionAuthHandler, protocolName: String, protocolUrl: String, event: AlicomFusionEvent) {
        // 实现协议点击的逻辑
        print("kakadeCallback 点击协议富文本")
        let responseModel = ResponseModel([
            "templateId": event.templateId ,
            "resultCode": event.resultCode,
            "resultMsg": event.resultMsg ,
            "innerCode": event.innerCode,
            "innerMsg": event.innerMsg
        ])
        flutterChannel.invokeMethod("onVerifyFailed", arguments: responseModel.json)
    }

    // 认证中断
    func onVerifyInterrupt(_ handler: AlicomFusionAuthHandler, event: AlicomFusionEvent) {
        // 实现认证中断的逻辑
        print("kakadeCallback 认证中断")
        let responseModel = ResponseModel([
            "resultCode": event.resultCode,
            "resultMsg": event.resultMsg ,
            "innerCode": event.innerCode,
            "innerMsg": event.innerMsg
        ])
        flutterChannel.invokeMethod("onVerifyInterrupt", arguments: responseModel.json)
    }

    // 场景事件回调
    func onAuthEvent(_ handler: AlicomFusionAuthHandler, eventData: AlicomFusionEvent) {
        print("收到认证事件：\(eventData)")
        var eventDictionary: [String: Any] = [
            "templateId": eventData.templateId ,
            "nodeId": eventData.nodeId ,
            "resultCode": eventData.resultCode,
            "resultMsg": eventData.resultMsg ,
            "innerCode": eventData.innerCode ,
            "innerMsg": eventData.innerMsg ,
            "carrierFailedResultData": eventData.carrierFailedResultData ,
            "innerRequestId": eventData.innerRequestId ,
            "requestId": eventData.requestId,
            "extendData": eventData.extendData,
        ]
        for (key, value) in eventData.extendData {
            if let stringKey = key as? String {
                eventDictionary[stringKey] = value
            }
        }
        let responseModel = ResponseModel(eventDictionary)
        flutterChannel.invokeMethod("onAuthEvent", arguments: responseModel.json)
    }
}
#endif