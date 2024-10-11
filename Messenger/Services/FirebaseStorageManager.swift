//
//  FirebaseStorageManager.swift
//  Messenger
//
//  Created by Паша Настусевич on 9.10.24.
//

import Firebase
import FirebaseStorage
import FirebaseAuth


class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    private init() {}
    
    let storageReference = Storage.storage().reference()
    
    private var avatarReference: StorageReference {
        return storageReference.child("avatars")
    }
    
    private var chatsReference: StorageReference {
        return storageReference.child("chats")
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
            guard let _ = metadata else {
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
    
    func uploadImageMessage(photo: UIImage, to chat: ModelChat, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let scaleledImage = photo.scaledToSafeUploadSize,
              let imageData = scaleledImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let uid: String = Auth.auth().currentUser?.uid ?? ""
        let chatName = [chat.friendUserName, uid].joined()
        
        self.chatsReference.child(chatName).child(imageName).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.chatsReference.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    func dowloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
