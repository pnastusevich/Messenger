//
//  OneLineTextField.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .arial20()) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomView: UIView = {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            view.backgroundColor = .mainGrayColor()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        self.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
            ])
            
        
    }
}
