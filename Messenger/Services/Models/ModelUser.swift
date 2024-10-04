//
//  ModelUser.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//

struct ModelUser: Hashable, Decodable {
    var username: String
    var email: String
    var avatarStringURL: String
    var description: String
    var gender: String
    var id: String
    
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
