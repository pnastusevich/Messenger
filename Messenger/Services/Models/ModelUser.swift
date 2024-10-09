//
//  ModelUser.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//

import FirebaseFirestore

struct ModelUser: Hashable, Decodable {
    var username: String
    var email: String
    var avatarStringURL: String
    var description: String
    var gender: String
    var id: String
    
    init(username: String, email: String, avatarStringURL: String, description: String, gender: String, id: String) {
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.gender = gender
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
         let email = data["email"] as? String,
         let avatarStringURL = data["avatarStringURL"] as? String,
         let description = data["description"] as? String,
         let gender = data["gender"] as? String,
         let id = data["uid"] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.gender = gender
        self.id = id
    }
    
    var representation: [String: Any] {
        var representation = ["username": username]
        representation["email"] = email
        representation["avatarStringURL"] = avatarStringURL
        representation["description"] = description
        representation["gender"] = gender
        representation["uid"] = id
        return representation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ModelUser, rhs: ModelUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowerCasedFilter = filter.lowercased()
        return username.lowercased().contains(lowerCasedFilter)
    }
}
