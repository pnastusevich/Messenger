//
//  SignUpViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private let welcomeLabel = UILabel(text: "Good to see you!", font: .arial26())
    private let alreadyOnboardLabel = UILabel(text: "Alredy onboard?")
    
    private let signUpButton = UIButton(title: "Sign Up", titleColor: .mainWhite, backgroundColor: .mainDark, cornerRadius: 10)
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .arial20()
        button.setTitleColor(.mainRed, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let emailTextField = OneLineTextField(font: .arial20(), placeholder: "Email")
    private let passwordTextField = OneLineTextField(font: .arial20(), placeholder: "Password")
    private let confirmPasswordTextField = OneLineTextField(font: .arial20(), placeholder: "Confirm password")
    
    weak var delegate: AuthNavigationDelegate?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTapped() {
        AuthStorageManager.shared.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Done", message: "You registered successfully") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true)
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    @objc private func loginButtonTapped() {
        self.dismiss(animated:  true) {
            self.delegate?.toLoginViewControler()
        }
    }
}

// MARK: - Setup View
private extension SignUpViewController {
    func setupView() {
        view.backgroundColor = .white
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        alreadyOnboardLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        setupSubviews(welcomeLabel, alreadyOnboardLabel, signUpButton, loginButton, emailTextField, passwordTextField, confirmPasswordTextField)
        setupConstraints()
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
        
        emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        emailTextField.heightAnchor.constraint(equalToConstant: 50),
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
        
        signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 40),
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        signUpButton.heightAnchor.constraint(equalToConstant: 60),
        
        alreadyOnboardLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 60),
        alreadyOnboardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        alreadyOnboardLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        
        loginButton.centerYAnchor.constraint(equalTo: alreadyOnboardLabel.centerYAnchor),
        loginButton.leadingAnchor.constraint(equalTo: alreadyOnboardLabel.trailingAnchor, constant: -140),
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

#Preview {
    SignUpViewController()
}
