import Foundation

struct AuthConfig {
    var tokenStr: String
    var iosSchemeCode: String
    var enableLog: Bool
    var authUIConfig: AuthUIConfig

    init(params: [String: Any]) {
        tokenStr = params["tokenStr"] as? String ?? ""
        iosSchemeCode = params["iosSchemeCode"] as? String ?? ""
        enableLog = params["enableLog"] as? Bool ?? false
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        authUIConfig = (try? decoder.decode(AuthUIConfig.self, from: JSONSerialization.data(withJSONObject: params["authUIConfig"] ?? "{}", options: []))) ?? AuthUIConfig()
    }
}

struct AuthUIConfig: Codable {
    
    // 导航栏（只对全屏模式有效）
    var navTitle: String?
    var navColor: String? // 十六进制的颜色
    var hideNavBackItem: Bool?
    var navBackImage: String? 

    // slogan
    var sloganText: String?

    // 背景
    var backgroundColor: String? // 十六进制的颜色
    
    // 切换到其他方式
    var changeBtnIsHidden: Bool?
}

