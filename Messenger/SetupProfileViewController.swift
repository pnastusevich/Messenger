//
//  SetupProfileViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let fullImageView = AddPhotoView()

    let welcomeLabel = UILabel(text: "Setup your profile", font: .arial26())
    
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let genderLabel = UILabel(text: "Gender")

    let fullNameTextField = OneLineTextField(font: .arial20())
    let aboutMeTextField = OneLineTextField(font: .arial20())
    
    let genderSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatsButton = UIButton(title: "Go to chats", titleColor: .mainWhiteColor(), backgroundColor: .mainDarkColor(), cornerRadius: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
}

// MARK: - Setup Constraints
extension SetupProfileViewController {
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                            axis: .vertical,
                                            spacing: 0)
        
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                           axis: .vertical,
                                           spacing: 0)
        
        let genderStackView = UIStackView(arrangedSubviews: [genderLabel, genderSegmentedControl],
                                          axis: .vertical,
                                          spacing: 12)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, genderStackView, goToChatsButton],
                                    axis: .vertical,
                                    spacing: 40)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (160)),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            ])
    }
}

#Preview {
    SetupProfileViewController()
}
