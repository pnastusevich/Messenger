//
//  ViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 30.09.24.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private var logoLabel: UILabel = {
        let label = UILabel()
        label.font = .arial40()
        label.textColor = .mainDark
        label.text = "Messenger"
        return label
    }()
    
    private let googleLabel = UILabel(text: "Get started with Google")
    private let emailLabel = UILabel(text: "Or sign up with")
    private let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .mainWhite, isShadow: true)
    private let emailButton = UIButton(title: "Email", titleColor: .mainWhite, backgroundColor: .mainDark)
    private let loginButton = UIButton(title: "Login", titleColor: .mainRed, backgroundColor: .mainWhite, isShadow: true)
    
    let signUpViewController = SignUpViewController()
    let loginViewController = LoginViewController()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        signUpViewController.delegate = self
        loginViewController.delegate = self
    }
    
    // MARK: - Navigation
    @objc private func emailButtonTapped() {
        present(signUpViewController, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
      
        present(loginViewController, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        AuthStorageManager.shared.googleLogin(presentingViewController: self) { result in
                   switch result {
                   case .success(let user):
                       FirestoreStorageManager.shared.getUserData(user: user) { result in
                           switch result {
                           case .success(let modelUser):
                               self.showAlert(title: "Done", message: "You are registered") {
                                   let mainTabBarController = MainTabBarController(currentUser: modelUser)
                                   mainTabBarController.modalPresentationStyle = .fullScreen
                                   self.present(mainTabBarController, animated: true, completion: nil)
                               }
                           case .failure(_):
                               self.showAlert(title: "Done", message: "You are registered") {
                                   self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                               }
                           }
                       }
                   case .failure(let error):
                       self.showAlert(title: "Error", message: error.localizedDescription)
                   }
               }
    }
}

// MARK: - Setup View
private extension AuthViewController {
    func setupView() {
        view.backgroundColor = .white
        googleButton.costomizeGoogleButton()
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        googleLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        alreadyOnboardLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
     
        setupSubviews(logoLabel, googleLabel, emailLabel, alreadyOnboardLabel, googleButton, emailButton, loginButton)
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
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            googleLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 100),
            googleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            googleButton.topAnchor.constraint(equalTo: googleLabel.bottomAnchor, constant: 20),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            googleButton.heightAnchor.constraint(equalToConstant: 60),
            
            emailLabel.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailButton.heightAnchor.constraint(equalToConstant: 60),
            
            alreadyOnboardLabel.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 40),
            alreadyOnboardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            alreadyOnboardLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            loginButton.topAnchor.constraint(equalTo: alreadyOnboardLabel.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension AuthViewController: AuthNavigationDelegate {
    func toLoginViewControler() {
        present(loginViewController, animated: true)
    }
    
    func toSignUpViewController() {
        present(signUpViewController, animated: true)
    }
}


#Preview {
    AuthViewController()
}


