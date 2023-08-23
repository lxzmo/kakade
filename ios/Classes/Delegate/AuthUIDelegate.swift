#if targetEnvironment(simulator)   
#else
import AlicomFusionAuth
import Foundation
import UIKit

class AuthUIDelegate: NSObject, AlicomFusionAuthUIDelegate {
    private let instance: SwiftKakadePlugin

    init(instance: SwiftKakadePlugin) {
        self.instance = instance
        super.init()
    }

    // 一键登录自定义UI
    func onPhoneNumberVerifyUICustomDefined(_ handler:AlicomFusionAuthHandler,templateId:String,nodeId:String,uiModel model:AlicomFusionNumberAuthModel){
        // 实现自定义UI的逻辑
        let config: AuthUIConfig = instance.authConfig?.authUIConfig ?? AuthUIConfig()

        // 导航栏（只对全屏模式有效）
        model.navTitle = NSAttributedString(string:config.navTitle ?? "", attributes:[:])
        model.hideNavBackItem = config.hideNavBackItem ?? false;
        if let navColor = config.navColor {
            model.navColor = navColor.uicolor()
        }else{
            if #available(iOS 13.0, *) {
                model.navColor = UIColor.systemBackground
            }
        }
        model.navBackImage = { () -> UIImage in
          guard let navBackImage = config.navBackImage else {
              return instance.authUIBuilder.BundleImage("icon_nav_back_gray")!
          }
            return instance.authUIBuilder.FlutterAssetImage(navBackImage)!
        }()

        // slogan
        model.sloganText = NSAttributedString(string: config.sloganText ?? "本机号码", attributes:[:])

        // 背景
        if let backgroundColor = config.backgroundColor {
            model.backgroundColor = backgroundColor.uicolor()
        }else{
            if #available(iOS 13.0, *) {
                model.backgroundColor = UIColor.systemBackground
            }
        }

        // 切换到其他方式
        model.changeBtnIsHidden = config.changeBtnIsHidden ?? false;
        
    }
}
#endif