//
//  ModelChat.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//


struct ModelChat: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ModelChat, rhs: ModelChat) -> Bool {
        return lhs.id == rhs.id
    }
}
