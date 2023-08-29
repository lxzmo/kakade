import UIKit

class ImageWithColor {
    static func demoImage(with color: UIColor, size: CGSize, isRoundedCorner: Bool, radius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if isRoundedCorner {
                var roundedRadius = radius
                if roundedRadius < 0 {
                    roundedRadius = 0
                }
                let rect = CGRect(origin: .zero, size: size)
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                if let context = UIGraphicsGetCurrentContext() {
                    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: roundedRadius, height: roundedRadius))
                    context.addPath(path.cgPath)
                    context.clip()
                    image?.draw(in: rect)
                    context.drawPath(using: .fillStroke)
                    image = UIGraphicsGetImageFromCurrentImageContext()
                }
                UIGraphicsEndImageContext()
            }

            return image
        }

        return nil
    }

    static func getDemoStatusBarHeight() -> CGFloat {
        var height: CGFloat = 20.0
        var isStatusBarHidden = false
        let statusFrame = UIApplication.shared.statusBarFrame

        if statusFrame.size.height == CGRect.zero.size.height {
            isStatusBarHidden = true
            height = 0.0
        }

        var window: UIWindow?
        
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                if let connectedScenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene>  {
                    for windowScene in connectedScenes {
                        if windowScene.activationState == .foregroundActive {
                            if let firstWindow = windowScene.windows.first {
                                window = firstWindow
                                break
                            }
                        }
                    }
                }
            }
            
            if window == nil {
                window = UIApplication.shared.keyWindow
            }
            
            if let safeAreaInsets = window?.safeAreaInsets {
                height = safeAreaInsets.top
            }
            
            if height < 0.1 && !isStatusBarHidden {
                height = statusFrame.size.height
            }
        }


        return height
    }
}
