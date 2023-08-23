import AlicomFusionAuth
import Foundation

class AuthUIBuilder {
    var register: FlutterPluginRegistrar?

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
}