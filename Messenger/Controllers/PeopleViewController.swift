//
//  PeopleViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit

class PeopleViewController: UIViewController {
    
    let users = Bundle.main.decode([ModelUser].self, from: "users.json")
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ModelUser>!
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData(with: nil)
        }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .mainWhite
        view.addSubview(collectionView)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
    }
    
    private func reloadData(with searchText: String?) {
        
        let filtred = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ModelUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filtred, toSection: .users)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
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


extension PeopleViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ModelUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, user in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .users:
                return self.configureCell(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {
                fatalError("Creating section header failed")
            }
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unowned section kind")
            }
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: items.count),
                                    font: .arial40(),
                                    textColor: .mainDark)
            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .users:
                return self.createUsersSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalWidth(0.6)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2
        )
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                        leading: spacing,
                                                        bottom: 0,
                                                        trailing: 0
        )
        section.interGroupSpacing = spacing
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return sectionHeader
    }
}


// MARK: UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

#Preview {
    MainTabBarController()
}
