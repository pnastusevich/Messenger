//
//  ActiveChatsCell.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit
import SDWebImage

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCellProtocol {
  
    static var reuseId = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name", font: .arial20())
    let lastMessage = UILabel(text: "How are you?", font: .arial16())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: .mainPurple, endColor: .mainBlue)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUICell()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: ModelChat = value as? ModelChat else { return }
        friendName.text = chat.friendUserName
        lastMessage.text = chat.lastMessageContent
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL), completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    // MARK: - Setup UI Cell
extension ActiveChatCell {
    func setupUICell() {
        backgroundColor = .white
        gradientView.backgroundColor = .mainDark
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.clipsToBounds = true
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        
        setupSubviews(friendImageView, gradientView, friendName, lastMessage)
        setupConstraints()
    }
    
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subviews in
            self.addSubview(subviews)
        }
    }
}

// MARK: - Setup Constraints
extension ActiveChatCell {
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),
            
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8),
            
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
        ])
    }
}

