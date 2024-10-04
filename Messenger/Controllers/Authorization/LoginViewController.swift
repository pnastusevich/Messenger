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
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sig In", for: .normal)
        button.titleLabel?.font = .arial20()
        button.setTitleColor(.mainRed, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

    }
    
    @objc private func loginButtonTapped() {
        AuthStorageManager.shared.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Done", message: "You are logged in") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true)
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpViewController()
        }
    }
}

// MARK: - Setup View
private extension LoginViewController {
    func setupView() {
        view.backgroundColor = .white

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        loginWithLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        needAnAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupSubviews(welcomeLabel, loginWithLabel, googleButton, orLabel, emailTextField, passwordTextField, loginButton, needAnAccountLabel, signUpButton)
        
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
            
            loginWithLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 80),
            loginWithLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginWithLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            googleButton.topAnchor.constraint(equalTo: loginWithLabel.bottomAnchor, constant: 20),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            googleButton.heightAnchor.constraint(equalToConstant: 60),
            
            orLabel.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 25),
            orLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            orLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailTextField.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 25),
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
            
            needAnAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            needAnAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            needAnAccountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            signUpButton.centerYAnchor.constraint(equalTo: needAnAccountLabel.centerYAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: needAnAccountLabel.trailingAnchor, constant: -140),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
    }
}

extension LoginViewController {
    private func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

#Preview {
    LoginViewController()
}
