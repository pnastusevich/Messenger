//
//  FirebaseStorageManager.swift
//  Messenger
//
//  Created by Паша Настусевич on 9.10.24.
//

import UIKit
import FirebaseStorage
import FirebaseAuth


class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    private init() {}
    
    let storageReference = Storage.storage().reference()
    private var avatarReference: StorageReference {
        return storageReference.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaleledImage = photo.scaledToSafeUploadSize,
              let imageData = scaleledImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarReference.child(currentUserId).putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error!))
                return
            }
            self.avatarReference.child(self.currentUserId).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
        
        
    }
}
