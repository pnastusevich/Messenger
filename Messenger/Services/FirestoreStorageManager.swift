//
//  FirestoreStorageManager.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import Firebase
import FirebaseFirestore

class FirestoreStorageManager {
    
    static let shared = FirestoreStorageManager()
    
    let dataBase = Firestore.firestore()
    
    private var userReference: CollectionReference {
        return dataBase.collection("users")
    }
    func saveProfileWith(id: String, email: String, username: String?, avatarImageString: String?, description: String?, gender: String?, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, gender: gender) else {
            completion(.failure(UserError.notFilled))
            return
        }
        let modelUser = ModelUser(username: username ?? "username not found",
                                  email: email,
                                  avatarStringURL: "not exist",
                                  description: description ?? "description not found",
                                  gender: gender ?? "gender not found",
                                  id: id
        )
        self.userReference.document(modelUser.id).setData(modelUser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else  {
                completion(.success(modelUser))
            }
        }
    }
}
