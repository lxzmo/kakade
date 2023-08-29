import AlicomFusionAuth
import Foundation

typealias CustomViewBlockCallback = (ResponseModel) -> Void

class AuthUIBuilder {
    var register: FlutterPluginRegistrar?
    var customViewBlockCallback: CustomViewBlockCallback?

    // 获取插件Assets下的图片
    func BundleImage(_ key: String) -> UIImage? {
        if let image = UIImage(named: key, in: PluginBundle, compatibleWith: nil) {
            return image
        }
        return nil
    }

    // 获取Flutter的image
    func FlutterAssetImage(_ key: String?) -> UIImage? {
        if key == nil || (key?.isEmpty) == nil {
            return nil
        }
        guard let path = getFlutterAssetsPath(key: key!) else {
            return nil
        }

        return UIImage(contentsOfFile: path)
    }

    // 获取Flutter Assets 路径
    func getFlutterAssetsPath(key: String) -> String? {
        let keyPath = self.register?.lookupKey(forAsset: key)
        return Bundle.main.path(forResource: keyPath, ofType: nil)
    }

    // 获取插件资源
    var PluginBundle: Bundle? {
        if let path = Bundle(for: SwiftKakadePlugin.self).path(forResource: "AlicomFusionAuth", ofType: "bundle") {
            let bundle = Bundle(path: path)
            return bundle
        } 
        return nil
    }

    func isHorizontal(_ screenSize: CGSize) -> Bool {
        screenSize.width > screenSize.height
    }

    // 构建自定义控件
    func buildCustomViewBlock(model: AlicomFusionNumberAuthModel, customViewConfigList: [CustomViewBlock],completionHandler: @escaping CustomViewBlockCallback) {
        self.customViewBlockCallback = completionHandler
        var customViewList: [UIView] = []
        for index in 0 ..< customViewConfigList.count {
            let customView = UIButton(type: UIButton.ButtonType.custom)
            let customViewConfig = customViewConfigList[index]
            if let text = customViewConfig.text {
                customView.setTitle(text, for: UIControl.State.normal)
            }
            if let textColor = customViewConfig.textColor {
                customView.setTitleColor(textColor.uicolor(), for: UIControl.State.normal)
            }
            if let textSize = customViewConfig.textSize {
                customView.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(textSize))
            }
            if let backgroundColor = customViewConfig.backgroundColor {
                customView.backgroundColor = backgroundColor.uicolor()
            }
            if let image = customViewConfig.image {
                if let imageFromFlutter = FlutterAssetImage(image) {
                    customView.setImage(imageFromFlutter, for: UIControl.State.normal)
                    customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    customView.imageView?.contentMode = .scaleAspectFill
                }
            }
            if customViewConfig.enableTap ?? false {
                // 添加点击事件
                if let viewId = customViewConfig.viewId {
                    customView.tag = viewId
                    customView.addTarget(self, action: #selector(self.customBtnOnTap), for: UIControl.Event.touchUpInside)
                }
            }
            customViewList.append(customView)
        }
        model.customViewBlock = { superCustomView in
            for index in 0 ..< customViewList.count {
                superCustomView.addSubview(customViewList[index])
            }
        }
        // model.customViewLayoutBlock = { _, _, _, _, _, _, _, _, _, _, _, _ in
        //     for index in 0 ..< customViewConfigList.count {
        //         let customViewConfig = customViewConfigList[index]
        //         let customViewBlock = customViewList[index]
        //         let x: Double = customViewConfig.offsetX ?? 0
        //         let y: Double = customViewConfig.offsetY ?? 0
        //         let width: Double = customViewConfig.width ?? 40
        //         let height: Double = customViewConfig.height ?? 40
        //         customViewBlock.frame = CGRect(x: x, y: y, width: width, height: height)
        //     }
        // }
    }

    // 自定义控件的点击事件
    @objc func customBtnOnTap(sender: UIButton) {
        // 回调自定义控件的点击事件，并且把viewId传递到flutter
        if let callback = customViewBlockCallback {
            let responseModel = ResponseModel(code: OnCustomViewTapCode, msg: String(describing: sender.tag))
            callback(responseModel)
        }
    }

}