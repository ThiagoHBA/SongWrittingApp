//
//  SecureClient.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Security

public protocol SecureClient {
    var server: String { get }

    func saveData(_ data: Data) throws
    func getData() throws -> Data
    func deleteData() throws
}

public typealias SecurePersistenceClient = SecureClient

public final class SecureClientImpl: SecureClient {
    public let server: String
    private let keychain: KeychainClient

    public init(server: String) {
        self.server = server
        self.keychain = SystemKeychainClient()
    }

    init(server: String, keychain: KeychainClient) {
        self.server = server
        self.keychain = keychain
    }

    public func saveData(_ data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecValueData as String: data
        ]

        let status = keychain.add(query as CFDictionary)

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
        let status = keychain.copyMatching(query as CFDictionary, &item)
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

        let status = keychain.delete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecurePersistenceError.unhandledError(status: status)
        }
    }
}
