//
//  OneLineTextField.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .arial20(), placeholder: String?) {
        self.init()
        
        self.font = font
        self.placeholder = placeholder
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.textColor = .darkGray
        self.font = .arial20()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
              self.leftView = paddingView
              self.leftViewMode = .always
        
    }
}
