//
//  ListenerService.swift
//  Messenger
//
//  Created by Паша Настусевич on 9.10.24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    
    private let dataBase = Firestore.firestore()
    
    private  var usersRef: CollectionReference {
        dataBase.collection("users")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserver(users: [ModelUser], completion: @escaping (Result<[ModelUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let modelUser = ModelUser(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !users.contains(modelUser) else { return }
                    guard modelUser.id != self.currentUserId else { return }
                    users.append(modelUser)
                case .modified:
                    guard let index = users.firstIndex(of: modelUser) else { return }
                    users[index] = modelUser
                case .removed:
                    guard let index = users.firstIndex(of: modelUser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    func waitingChatsObserve(chats: [ModelChat], completion: @escaping (Result<[ModelChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        
        let chatsRef =  dataBase.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
    
        let chatsListener = chatsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { difference in
                guard let modelChat = ModelChat(document: difference.document) else { return }
                
                switch difference.type {
                case .added:
                    if !chats.contains(modelChat) {
                        chats.append(modelChat)
                    }
                case .modified:
                    if let index = chats.firstIndex(of: modelChat)  {
                        chats[index] = modelChat
                    }
                case .removed:
                    if let index = chats.firstIndex(of: modelChat) {
                        chats.remove(at: index)
                    }
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
    func activeChatsObserve(chats: [ModelChat], completion: @escaping (Result<[ModelChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        
        let chatsRef = dataBase.collection("users").document(currentUserId).collection("activeChats")
        let chatsListener = chatsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let chat = ModelChat(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
    func messagesObserve(chat: ModelChat, completion: @escaping (Result<ModelMessage, Error>) -> Void) -> ListenerRegistration? {
        let ref = usersRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        let messagesListener = ref.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let message = ModelMessage(document: diff.document) else { return }
                switch diff.type {
                    
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messagesListener
    }
}
