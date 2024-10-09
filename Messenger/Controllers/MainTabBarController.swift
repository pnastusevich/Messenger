//
//  MainTabBarController.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: ModelUser
    
    init(currentUser: ModelUser = ModelUser(username: "Имя",
                                            email: "Мейл",
                                            avatarStringURL: "аватар",
                                            description: "описание",
                                            gender: "гендер",
                                            id: "айди")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listVC = ListViewController(currentUser: currentUser)
        let peopleVC = PeopleViewController(currentUser: currentUser)
            
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        guard let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig) else { return }
        guard let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig) else { return }
    
        viewControllers = [
            generateNavigationController(rootViewController: peopleVC,
                                         title: "People",
                                         image: peopleImage),
            generateNavigationController(rootViewController: listVC,
                                         title: "Chats",
                                         image: convImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
