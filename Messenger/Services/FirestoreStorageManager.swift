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
    
    private var waitingChatsRef: CollectionReference {
        return dataBase.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
        return dataBase.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: ModelUser!
    
    func getUserData(user: User, completion: @escaping (Result<ModelUser, Error>) -> Void) {
        let docReference = userReference.document(user.uid)
        docReference.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let modelUser = ModelUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapModelUser))
                    return
                }
                self.currentUser = modelUser
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
    
    func createWaitingChat(message: String, receiver: ModelUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = dataBase.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = ModelMessage(user: currentUser, content: message)
        
        let chat = ModelChat(friendUserName: currentUser.username,
                             friendAvatarStringURL: currentUser.avatarStringURL,
                             lastMessageContent: message.content,
                             friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func deleteWaitingChat(chat: ModelChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsRef.document(chat.friendId).delete { error in
            if let error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: ModelChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { error in
                        if let error {
                            completion(.failure(error))
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessages(chat: ModelChat, completion: @escaping (Result<[ModelMessage], Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [ModelMessage]()
        
        reference.getDocuments { querySnapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = ModelMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func changeToActive(chat: ModelChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
                
            case .success(let messages):
                self.deleteMessages(chat: chat) { result in
                    switch result {
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: ModelChat, messages: [ModelMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        
        activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
            if let error {
                completion(.failure(error))
                return
            }
            for massage in messages {
                messageRef.addDocument(data: massage.representation) { error in
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func sendMessage(chat: ModelChat, message: ModelMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = userReference.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("messages")
        let myMessageRef = userReference.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = ModelChat(friendUserName: currentUser.username,
                                      friendAvatarStringURL: currentUser.avatarStringURL,
                                      lastMessageContent: message.content,
                                      friendId: currentUser.id
        )
        friendRef.setData(chatForFriend.representation) { error in
            if let error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { error in
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
