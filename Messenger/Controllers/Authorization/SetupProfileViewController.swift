//
//  SetupProfileViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 1.10.24.
//

import FirebaseAuth
import UIKit
import SDWebImage

final class SetupProfileViewController: UIViewController {
    
    private let fullImageView = AddPhotoView()

    private let welcomeLabel = UILabel(text: "Setup your profile", font: .arial26())
    private let genderLabel = UILabel(text: "Gender")

    private let fullNameTextField = OneLineTextField(font: .arial20(), placeholder: "Full name")
    private let aboutMeTextField = OneLineTextField(font: .arial20(), placeholder: "About me")
    
    private let genderSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    private let goToChatsButton = UIButton(title: "Go to chats", titleColor: .mainWhite, backgroundColor: .mainDark, cornerRadius: 10)
    
    private let currentUser: User
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let myImage = #imageLiteral(resourceName: "plus")
        button.setImage(myImage, for: .normal)
        button.tintColor = .mainDark
        return button
    }()
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        // to do set google image
        if let photoURL = currentUser.photoURL {
            fullImageView.circleImageView.sd_setImage(with: photoURL, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func goToChatsButtonTapped() {
        guard let userEmail = currentUser.email else { return }
        
        FirestoreStorageManager.shared.saveProfileWith(
            id: currentUser.uid,
            email: userEmail,
            username: fullNameTextField.text,
            avatarImage: fullImageView.circleImageView.image,
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
        
        setupSubviews(fullImageView, welcomeLabel, genderLabel, fullNameTextField, aboutMeTextField, genderSegmentedControl, goToChatsButton, plusButton)
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
            
            plusButton.leadingAnchor.constraint(equalTo: fullImageView.trailingAnchor, constant: 16),
            plusButton.centerYAnchor.constraint(equalTo: fullImageView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            
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

// MARK: - UIImagePickerControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        fullImageView.circleImageView.image = image
    }
}
                
#Preview {
    SetupProfileViewController(currentUser: Auth.auth().currentUser!)
}
