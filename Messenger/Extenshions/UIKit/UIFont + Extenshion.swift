//
//  UIFont + Extenshion.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit

extension UIFont {
    static func arial20() -> UIFont {
        return UIFont.init(name: "Arial", size: 20)!
    }
    
    static func arial26() -> UIFont {
        return UIFont.boldSystemFont(ofSize: 26)
    }
    
    static func arial40() -> UIFont {
        return UIFont.boldSystemFont(ofSize: 40)
    }
    
    static func arial16() -> UIFont {
        return UIFont.init(name: "Arial", size: 16)!
    }
}
