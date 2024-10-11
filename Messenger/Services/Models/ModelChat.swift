//
//  ModelChat.swift
//  Messenger
//
//  Created by Паша Настусевич on 3.10.24.
//

import UIKit

import FirebaseFirestore

struct ModelChat: Hashable, Decodable {
    var friendUserName: String
    var friendAvatarStringURL: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUserName": friendUserName]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    
    init(friendUserName: String, friendAvatarStringURL: String, lastMessageContent: String, friendId: String) {
        self.friendUserName = friendUserName
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()  
        guard let friendUserName = data["friendUserName"] as? String,
              let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
              let lastMessageContent = data["lastMessage"] as? String,
              let friendId = data["friendId"] as? String else { return nil }
        self.friendUserName = friendUserName
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    init?(newDoc: QueryDocumentSnapshot) {
        let data = newDoc.data()
        guard let friendId = data["friendId"] as? String else { return nil }
        self.friendId = friendId
        self.friendUserName = ""
        self.friendAvatarStringURL = ""
        self.lastMessageContent = ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ModelChat, rhs: ModelChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
