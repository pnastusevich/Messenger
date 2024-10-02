//
//  MainTabBarController.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listVC = ListViewController()
        let peopleVC = PeopleViewController()
            
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        guard let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig) else { return }
        guard let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig) else { return }
    
        viewControllers = [
            generateNavigationController(rootViewController: listVC,
                                         title: "Chats",
                                         image: convImage),
            generateNavigationController(rootViewController: peopleVC,
                                         title: "People",
                                         image: peopleImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
