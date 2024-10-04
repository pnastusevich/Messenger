//
//  UserError.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import Foundation

enum UserError: Error {
    case notFilled
    case photoNotExist
}

extension UserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Поля не заполнены", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Пользваотель не выбрал фотографию", comment: "")
        }
    }
}
