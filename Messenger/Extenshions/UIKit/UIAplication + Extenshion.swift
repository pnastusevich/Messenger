//
//  UIAplication + Extenshion.swift
//  Messenger
//
//  Created by Паша Настусевич on 9.10.24.
//

import UIKit

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.getKeyWindow()?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func getKeyWindow() -> UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow }
    }
}
