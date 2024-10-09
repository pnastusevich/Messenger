//
//  SetupProfileViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import FirebaseAuth
import UIKit

final class SetupProfileViewController: UIViewController {
    
    private let fullImageView = AddPhotoView()

    private let welcomeLabel = UILabel(text: "Setup your profile", font: .arial26())
    private let genderLabel = UILabel(text: "Gender")

    private let fullNameTextField = OneLineTextField(font: .arial20(), placeholder: "Full name")
    private let aboutMeTextField = OneLineTextField(font: .arial20(), placeholder: "About me")
    
    private let genderSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    private let goToChatsButton = UIButton(title: "Go to chats", titleColor: .mainWhite, backgroundColor: .mainDark, cornerRadius: 10)
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        // to do set google image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func goToChatsButtonTapped() {
        guard let userEmail = currentUser.email else { return }
        
        FirestoreStorageManager.shared.saveProfileWith(
            id: currentUser.uid,
            email: userEmail,
            username: fullNameTextField.text,
            avatarImageString: "nil",
            description: aboutMeTextField.text,
            gender: genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)) { result in
                switch result {
                case .success(let modelUser):
                    self.showAlert(title: "Успешно", message: "Приятного общения") {
                        let mainTabBarController = MainTabBarController(currentUser: modelUser)
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        self.present(mainTabBarController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
    }
}

// MARK: - Setup View
private extension SetupProfileViewController {
    func setupView() {
        view.backgroundColor = .white
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTextField.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        goToChatsButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupSubviews(fullImageView, welcomeLabel, genderLabel, fullNameTextField, aboutMeTextField, genderSegmentedControl, goToChatsButton)
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
            
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fullNameTextField.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            fullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            fullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            aboutMeTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 40),
            aboutMeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            aboutMeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            aboutMeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            genderLabel.topAnchor.constraint(equalTo: aboutMeTextField.bottomAnchor, constant: 40),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            genderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 12),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            genderSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            goToChatsButton.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 40),
            goToChatsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            goToChatsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            goToChatsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
                
#Preview {
    SetupProfileViewController(currentUser: Auth.auth().currentUser!)
}
