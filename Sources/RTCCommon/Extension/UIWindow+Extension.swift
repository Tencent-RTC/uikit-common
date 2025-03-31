//
//  UIWindow+Extension.swift
//  Pods
//
//  Created by vincepzhang on 2025/2/21.
//

extension UIWindow {
    public func t_makeKeyAndVisible() {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if windowScene.activationState == UIScene.ActivationState.foregroundActive ||
                    windowScene.activationState == UIScene.ActivationState.background ||
                    windowScene.activationState == UIScene.ActivationState.foregroundInactive {
                    self.windowScene = windowScene as? UIWindowScene
                    break
                }
            }
        }
        self.makeKeyAndVisible()
    }
    
    public static func getKeyWindow() -> UIWindow? {
        var keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }
}
