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

        // let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        // label.text = config.nameLabelText ?? "登录"
        // label.textColor = (config.nameLabelColor ?? "#262626").uicolor()
        // label.font = UIFont.systemFont(ofSize: CGFloat(config.nameLabelSize ?? 24))
        // label.sizeToFit()
        // model.nameLabel = label

        // 竖屏、横屏模式设置
        // model.supportedInterfaceOrientations = .portrait

        // 状态栏
        // model.prefersStatusBarHidden = config.prefersStatusBarHidden ?? false
        // if #available(iOS 13.0, *) {
        //     model.preferredStatusBarStyle = UIStatusBarStyle.darkContent
        // } else {
        //     model.preferredStatusBarStyle = UIStatusBarStyle.default
        // }

        // 导航栏（只对全屏模式有效）
        model.navTitle = NSAttributedString(string:config.navTitle ?? "", attributes:[:])
        // model.hideNavBackItem = config.hideNavBackItem ?? false;
        // if let navColor = config.navColor {
        //     model.navColor = navColor.uicolor()
        // }else{
        //     if #available(iOS 13.0, *) {
        //         model.navColor = UIColor.systemBackground
        //     }
        // }
        // model.navBackImage = { () -> UIImage in
        //     guard let navBackImage = config.navBackImage else {
        //         return instance.authUIBuilder.BundleImage("icon_nav_back_gray")!
        //     }
        //     return instance.authUIBuilder.FlutterAssetImage(navBackImage)!
        // }()

        // slogan
        model.sloganIsHidden = config.sloganIsHidden ?? false;
        var sloganTextAtrributes: [NSAttributedString.Key: Any] = [:]
        sloganTextAtrributes.updateValue(
            (config.sloganTextColor ?? "#999999").uicolor(), 
            forKey: NSMutableAttributedString.Key.foregroundColor
        )
        sloganTextAtrributes.updateValue(
            UIFont(name: PF_Regular, size: CGFloat(config.sloganTextSize ?? Font_14))!,
            forKey: NSMutableAttributedString.Key.font
        )
        model.sloganText = NSAttributedString(
            string: config.sloganText ?? "本机号码", 
            attributes:sloganTextAtrributes
        )

        // 号码
        // model.numberColor = (config.numberColor ?? "#262626").uicolor()
        // model.numberFont = UIFont(name: PF_Bold, size: CGFloat(config.numberFontSize ?? Font_24))!

        // 登录
        // var loginAttribute: [NSAttributedString.Key: Any] = [:]
        // loginAttribute.updateValue(
        //     config.loginBtnTextColor?.uicolor() ?? UIColor.white, 
        //     forKey: NSAttributedString.Key.foregroundColor
        // )
        // loginAttribute.updateValue(
        //     UIFont(name: PF_Regular, size: CGFloat(config.loginBtnTextSize ?? Font_17))!, 
        //     forKey: NSAttributedString.Key.font
        // )
        // model.loginBtnText = NSAttributedString(
        //     string: config.loginBtnText ?? "本机号码一键登录", 
        //     attributes: loginAttribute
        // )
        // let loginBtnBgColor:UIColor = (config.loginBtnBgColor ?? "#0064C8").uicolor()
        // let imageSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 44)
        // let loginBtnBgImage:UIImage = ImageWithColor.demoImage(with: loginBtnBgColor, size: imageSize, isRoundedCorner: false, radius: 0.0)!
        // model.loginBtnBgImgs = [ loginBtnBgImage, loginBtnBgImage,  loginBtnBgImage ]
        // if let hideOtherLoginBtn = config.hideOtherLoginBtn, hideOtherLoginBtn {
        //     let otherLogin = UIButton(type: .custom)
        //     otherLogin.setTitle("", for: .normal)
        //     otherLogin.backgroundColor = UIColor.white
        //     model.otherLoginButton = otherLogin
        // }
       
        // 背景
        // if let backgroundColor = config.backgroundColor {
        //     model.backgroundColor = backgroundColor.uicolor()
        // }else{
        //     if #available(iOS 13.0, *) {
        //         model.backgroundColor = UIColor.systemBackground
        //     }
        // }

        // logo
        // model.logoIsHidden = config.logoIsHidden ?? false;

        // 切换到其他方式
        model.changeBtnIsHidden = config.changeBtnIsHidden ?? false;
        model.changeBtnTitle = NSAttributedString(string:config.changeBtnTitle ?? "更多登录方式 >", attributes:[:])

        // 协议
        // var checkBoxImages = [UIImage]()
        // if config.uncheckImage != nil {
        //     if let uncheckIcon = instance.authUIBuilder.FlutterAssetImage(config.uncheckImage) {
        //         checkBoxImages.append(uncheckIcon)
        //     }
        // } else {
        //     checkBoxImages.append(instance.authUIBuilder.BundleImage("icon_uncheck")!)
        // }
        // if config.checkedImage != nil {
        //     if let checkedIcon = instance.authUIBuilder.FlutterAssetImage(config.checkedImage) {
        //         checkBoxImages.append(checkedIcon)
        //     }
        // } else {
        //     checkBoxImages.append(instance.authUIBuilder.BundleImage("icon_check")!)
        // }
        // if !checkBoxImages.isEmpty {
        //     model.checkBoxImages = checkBoxImages
        // }
        
        // 自定义控件添加
        // if let customViewBlockList = config.customViewBlockList {
        //     instance.authUIBuilder.buildCustomViewBlock(model: model, customViewConfigList: customViewBlockList,completionHandler:{
        //          responseModel in
        //         self.instance.methodChannel?.invokeMethod(SwiftKakadePlugin.CALLBACK_EVENT, arguments: responseModel.json)
        //     })
        // }
    }
}
#endif
