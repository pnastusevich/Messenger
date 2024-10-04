//
//  Validators.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import Foundation

class Validators {
    
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let password,
              let confirmPassword,
              let email,
              password != "",
              confirmPassword != "",
              email != ""
        else { return false }
        
        return true
    }
    
    static func isFilled(username: String?, description: String?, gender: String?) -> Bool {
        guard let username,
              let description,
              let gender,
              username != "",
              description != "",
              gender != ""
        else { return false }
        
        return true
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return emailPredicate.evaluate(with: text)
    }
}
