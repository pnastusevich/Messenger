//
//  UserCell.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCellProtocol {
  
    let userImageView = UIImageView()
    let userNameLabel = UILabel(text: "text", font: .arial20())
    let containerView = UIView()
    
    static var reuseId = "WaitinChatCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        
       
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user: ModelUser = value as? ModelUser else { return }
        userImageView.image = UIImage(named: user.avatarStringURL)
        userNameLabel.text = user.username
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
    }

    
    private func setupCell() {
        
        backgroundColor = .white
        
        self.layer.shadowColor = UIColor.mainBrown.cgColor
        self.layer.cornerRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    
        userImageView.backgroundColor = .mainBlue
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userNameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    MainTabBarController()
}
