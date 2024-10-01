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
        button.contentHorizontalAlignment = .leading
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
       let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton],
                                         axis: .horizontal,
                                         spacing: 10)
       bottomStackView.alignment = .firstBaseline
       
       welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
       stackView.translatesAutoresizingMaskIntoConstraints = false
       bottomStackView.translatesAutoresizingMaskIntoConstraints = false
       
       view.addSubview(welcomeLabel)
       view.addSubview(stackView)
       view.addSubview(bottomStackView)
       
       NSLayoutConstraint.activate([
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        
        bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
       ])
    }
}

#Preview {
    SignUpViewController()
}
