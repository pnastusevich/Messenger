//
//  AuthStorageManager.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthStorageManager {
    
    static let shared = AuthStorageManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard Validators.isFilled(email: email,
                                  password: password,
                                  confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.paswordNotMatched))
            return
        }
        guard Validators.isValidEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let email, let password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
