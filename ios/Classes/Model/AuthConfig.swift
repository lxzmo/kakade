import Foundation

struct AuthConfig {
    var currentTemplatedId: String
    var tokenStr: String
    var iosSchemeCode: String
    var enableLog: Bool
    var authUIConfig: AuthUIConfig

    init(params: [String: Any]) {
        currentTemplatedId = params["currentTemplatedId"] as? String ?? ""
        tokenStr = params["tokenStr"] as? String ?? ""
        iosSchemeCode = params["iosSchemeCode"] as? String ?? ""
        enableLog = params["enableLog"] as? Bool ?? false
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        authUIConfig = (try? decoder.decode(AuthUIConfig.self, from: JSONSerialization.data(withJSONObject: params["authUIConfig"] ?? "{}", options: []))) ?? AuthUIConfig()
    }
}

struct AuthUIConfig: Codable {

    var nameLabelText: String?
    var nameLabelColor: String?
    var nameLabelSize: Int?

    // 是否隐藏 其他手机号登录 按钮
    var hideOtherLoginBtn: Bool?

    // 状态栏
    var prefersStatusBarHidden: Bool?
    
    // 导航栏（只对全屏模式有效）
    var navTitle: String?
    var navColor: String? // 十六进制的颜色
    var hideNavBackItem: Bool?
    var navBackImage: String? 

    // slogan
    var sloganIsHidden: Bool?
    var sloganText: String?
    var sloganTextColor: String?
    var sloganTextSize: Int?

    // 号码
    var numberColor: String?
    var numberFontSize: Int?

    // 登录
    var loginBtnText: String?
    var loginBtnTextColor: String?
    var loginBtnTextSize: Int?
    var loginBtnBgColor: String?

    // 背景
    var backgroundColor: String? // 十六进制的颜色

    // logo
    var logoImage: String?
    var logoWidth: Int?
    var logoHeight: Int?
    var logoIsHidden: Bool?
    
    // 切换到其他方式
    var changeBtnIsHidden: Bool?
    var changeBtnTitle: String?

    // 协议
    var checkedImage: String?
    var uncheckImage: String?

    // 自定义控件添加
    var customViewBlockList: [CustomViewBlock]?
}

// 自定义控件添加
struct CustomViewBlock: Codable {
    var viewId: Int?
    var text: String?
    var textColor: String?
    var textSize: Double?
    var backgroundColor: String?
    var image: String?
    var offsetX: Double?
    var offsetY: Double?
    var width: Double?
    var height: Double?
    var enableTap: Bool?
}