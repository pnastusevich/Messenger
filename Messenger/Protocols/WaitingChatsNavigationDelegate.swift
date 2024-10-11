//
//  WaitingChatsNavigation.swift
//  Messenger
//
//  Created by Паша Настусевич on 10.10.24.
//

protocol WaitingChatsNavigationDelegate: AnyObject {
    func removeWaitingChat(chat: ModelChat)
    func chatToActive(chat: ModelChat)
}
