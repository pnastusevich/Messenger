//
//  UIButton + Extenshion.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit

extension UIButton {
    
    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont? = .arial20(),
                     isShadow: Bool = false,
                     cornerRadius: CGFloat = 10
    ) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
        }
    }
    
    func costomizeGoogleButton() {
        let googleLogoImage = UIImageView(image: .googleLogo, contentMode: .scaleAspectFit)
        googleLogoImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleLogoImage)
        googleLogoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        googleLogoImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
