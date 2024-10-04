//
//  AuthError.swift
//  Messenger
//
//  Created by Паша Настусевич on 4.10.24.
//

import Foundation

enum AuthError: Error {
    case notFilled
    case invalidEmail
    case invalidPassword
    case paswordNotMatched
    case unownedErorr
    case serverError
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Поля не заполнены", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Некорректный формат email", comment: "")
        case .invalidPassword:
            return NSLocalizedString("Пароль меньше 6 символов", comment: "")
        case .paswordNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unownedErorr:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        }
    }
}
