//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
  
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let user = Auth.auth().currentUser {
            FirestoreStorageManager.shared.getUserData(user: user) { result in
                switch result {
                case .success(let currentUser):
                    let mainTabBarController = MainTabBarController(currentUser: currentUser)
                    mainTabBarController.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = mainTabBarController
                case .failure(_):
                    self.window?.rootViewController = AuthViewController()
                }
            }
            
        } else {
            window?.rootViewController = AuthViewController()
        }
        window?.makeKeyAndVisible()
    }




}

