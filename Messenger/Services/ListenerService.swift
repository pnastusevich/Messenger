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
        return Auth.auth().currentUser?.uid ?? ""
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
}
