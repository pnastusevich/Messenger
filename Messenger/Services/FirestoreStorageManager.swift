//
//  FirestoreStorageManager.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirestoreStorageManager {
    
    static let shared = FirestoreStorageManager()
    
    let dataBase = Firestore.firestore()
    
    private var userReference: CollectionReference {
        return dataBase.collection("users")
    }
    
    func getUserData(user: User, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        let docReference = userReference.document(user.uid)
        docReference.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let modelUser = ModelUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapModelUser))
                    return
                }
                completion(.success(modelUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
            
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, gender: String?, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, gender: gender) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var modelUser = ModelUser(username: username ?? "username not found",
                                  email: email,
                                  avatarStringURL: "not exist",
                                  description: description ?? "description not found",
                                  gender: gender ?? "gender not found",
                                  id: id
        )
        
        FirebaseStorageManager.shared.upload(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                modelUser.avatarStringURL = url.absoluteString
                self.userReference.document(modelUser.id).setData(modelUser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else  {
                        completion(.success(modelUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
