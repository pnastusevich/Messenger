//
//  ViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var logoLabel: UILabel = {
        let label = UILabel()
        label.font = .arial40()
        label.textColor = .mainDarkColor()
        label.text = "Messenger"
        return label
    }()
    
    let googleLabel = UILabel(text: "Get started with Google")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .mainWhiteColor(), isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .mainWhiteColor(), backgroundColor: .mainDarkColor())
    let loginButton = UIButton(title: "Login", titleColor: .mainRedColor(), backgroundColor: .mainWhiteColor(), isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        googleButton.costomizeGoogleButton()
        setupConstraints()
        
    }
}

// MARK: - Setup Constraints
extension AuthViewController {
    func setupConstraints() {
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [
                logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                stackView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 100),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ]
        )
    }

}

#Preview {
    AuthViewController()
}


