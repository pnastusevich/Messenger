//
//  AuthStorageManager.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthStorageManager {
    
    static let shared = AuthStorageManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    func googleLogin(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
           guard let clientID = FirebaseApp.app()?.options.clientID else {
               fatalError("No Client ID found in Firebase configuration.")
           }
        
           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.configuration = config

           GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               guard let user = result?.user,
                     let idToken = user.idToken?.tokenString else {
                   completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Google authentication failed"])))
                   return
               }

               let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
               Auth.auth().signIn(with: credential) { result, error in
                   guard let result = result else {
                       completion(.failure(error!))
                       return
                   }
                   completion(.success(result.user))
               }
           }
       }
    
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
