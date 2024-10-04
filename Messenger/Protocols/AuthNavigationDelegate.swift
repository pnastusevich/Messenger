//
//  AuthNavigationDelegate.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func toLoginViewControler()
    func toSignUpViewController()
}
