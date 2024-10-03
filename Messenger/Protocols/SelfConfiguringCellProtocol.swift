//
//  SelfConfiguringCellProtocol.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import Foundation

protocol SelfConfiguringCellProtocol {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
