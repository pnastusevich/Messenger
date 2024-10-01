//
//  SignUpViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Good to see you!", font: .arial26())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Alredy onboard?")
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .mainWhiteColor(), backgroundColor: .mainDarkColor(), cornerRadius: 10)
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .arial20()
        button.setTitleColor(.mainRedColor(), for: .normal)
        return button
    }()
    
    let emailTextField = OneLineTextField(font: .arial20())
    let passwordTextField = OneLineTextField(font: .arial20())
    let confirmPasswordTextField = OneLineTextField(font: .arial20())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
}

//MARK: - Setup Constraints
extension SignUpViewController {
    
   private func setupConstraints() {
       let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
       let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
       let confirmStackView = UIStackView(arrangedSubviews: [confirmLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
       
       signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       
       let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmStackView, signUpButton],
                                   axis: .vertical,
                                   spacing: 40)
       let buttonStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton],
                                         axis: .horizontal,
                                         spacing: -1)
       welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
       stackView.translatesAutoresizingMaskIntoConstraints = false
       buttonStackView.translatesAutoresizingMaskIntoConstraints = false
       
       view.addSubview(welcomeLabel)
       view.addSubview(stackView)
       view.addSubview(buttonStackView)
       
       NSLayoutConstraint.activate([
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        
        buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
        buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
       ])
    }
}

#Preview {
    SignUpViewController()
}
