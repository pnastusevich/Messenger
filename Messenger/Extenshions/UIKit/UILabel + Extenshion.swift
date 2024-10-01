//
//  UILabel + Extenshion.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .arial20()) {
        self.init()
        
        self.text = text
        self.font = font
        
    }
}
