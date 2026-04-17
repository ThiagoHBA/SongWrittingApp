//
//  SecurePersistenceError.swift
//  Infra
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

internal enum SecurePersistenceError: Error {
    case noData
    case unexpectedData
    case unhandledError(status: OSStatus)
}
