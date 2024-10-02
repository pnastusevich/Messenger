//
//  PeopleViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit

class PeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        setupSearchBar()
        }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}
// MARK: UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

#Preview {
    MainTabBarController()
}
