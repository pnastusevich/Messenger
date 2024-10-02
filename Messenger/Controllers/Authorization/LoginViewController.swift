//
//  loginViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let welcomeLabel = UILabel(text: "Welcome back", font: .arial26())
    
    private let loginWithLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let needAnAccountLabel = UILabel(text: "Need an account?")

    private let emailTextField = OneLineTextField(font: .arial20(), placeholder: "Email")
    private let passwordTextField = OneLineTextField(font: .arial20(), placeholder: "Password")
    
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .mainWhite, isShadow: true)
    private let loginButton = UIButton(title: "Login", titleColor: .mainWhite, backgroundColor: .mainDark)
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sig In", for: .normal)
        button.titleLabel?.font = .arial20()
        button.setTitleColor(.mainRed, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
}

// MARK: - Setup View
private extension LoginViewController {
    func setupView() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        loginWithLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        needAnAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupSubviews(welcomeLabel, loginWithLabel, googleButton, orLabel, emailTextField, passwordTextField, loginButton, needAnAccountLabel, signInButton)
        
        setupConstraints()
        googleButton.costomizeGoogleButton()
    }
    
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subviews in
            view.addSubview(subviews)
        }
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginWithLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
            loginWithLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginWithLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            googleButton.topAnchor.constraint(equalTo: loginWithLabel.bottomAnchor, constant: 20),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            googleButton.heightAnchor.constraint(equalToConstant: 60),
            
            orLabel.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 40),
            orLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            orLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailTextField.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            needAnAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50),
            needAnAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            needAnAccountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            signInButton.centerYAnchor.constraint(equalTo: needAnAccountLabel.centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: needAnAccountLabel.trailingAnchor, constant: -140),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
    }
}

#Preview {
    LoginViewController()
}
