//
//  UIViewController + Extenshion.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//

import UIKit

extension UIViewController {
    func configureCell<T: SelfConfiguringCellProtocol, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
}
