//
//  ChatRequestViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//

import UIKit
import SDWebImage

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: UIImage(named: "human5")!,
                                contentMode: .scaleAspectFill
    )
    let nameLabel = UILabel(text: "Peter Petegru", font: .arial20())
    let aboutMeLabel = UILabel(text: "You have the opportunity to start a new chat",
                               font: .arial16()
    )
    let acceptButton = UIButton(title: "Accept",
                                titleColor: .mainWhite,
                                backgroundColor: .mainDark,
                                font: .arial20(),
                                cornerRadius: 10
    )
    let denyButton = UIButton(title: "Deny",
                              titleColor: .mainRed,
                              backgroundColor: .mainWhite,
                              font: .arial20(),
                              cornerRadius: 10
    )
    
    private var chat: ModelChat
    weak var delegate: WaitingChatsNavigationDelegate?
    
    init(chat: ModelChat) {
        self.chat = chat
        nameLabel.text = chat.friendUserName
        imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc private func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.chatToActive(chat: self.chat)
        }
    }
}

extension ChatRequestViewController {
    private func setupUI() {
        view.backgroundColor = .mainWhite
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .mainWhite
        containerView.layer.cornerRadius = 30
        
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = UIColor.mainRed.cgColor
   
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(acceptButton)
        containerView.addSubview(denyButton)

        setupConstraints()
    }

//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.acceptButton.applyGradients(cornerRadius: 10)
//    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206),

            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            acceptButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 20),
            acceptButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            acceptButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -5),
            acceptButton.heightAnchor.constraint(equalToConstant: 55),
            
            denyButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 20),
            denyButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 5),
            denyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            denyButton.heightAnchor.constraint(equalToConstant: 55)
            ])
    }
}

