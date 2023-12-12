//
//  SecureClientImpl.swift
//  Infra
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Data

public final class SecureClientImpl: SecurePersistenceClient {
    public init() {}

    public func saveData(_ data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw SecurePersistenceError.unhandledError(status: status)
        }
    }

    public func getData() throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw SecurePersistenceError.noData }

        guard status == errSecSuccess else {
            throw SecurePersistenceError.unhandledError(status: status)
        }

        guard let existingItem = item as? [String: Any],
            let searchedData = existingItem[kSecValueData as String] as? Data
        else {
            throw SecurePersistenceError.unhandledError(status: status)
        }

        return searchedData
    }

    public func deleteData() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecurePersistenceError.unhandledError(status: status)
        }
    }
}
