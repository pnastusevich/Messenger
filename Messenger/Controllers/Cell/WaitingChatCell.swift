//
//  WaitingChatCell.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCellProtocol {

    static var reuseId = "WaitinChatCell"
    
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUICell()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let value: ModelChat = value as? ModelChat else { return }
        friendImageView.image = UIImage(named: value.userImageString)
    }
    
    private func setupUICell() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    MainTabBarController()
}
