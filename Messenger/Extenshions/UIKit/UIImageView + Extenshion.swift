//
//  UIImageView + Extenshion.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}

