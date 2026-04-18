//
//  KeychainClient.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import Security

protocol KeychainClient {
    func add(_ query: CFDictionary) -> OSStatus
    func copyMatching(
        _ query: CFDictionary,
        _ item: UnsafeMutablePointer<CFTypeRef?>?
    ) -> OSStatus
    func delete(_ query: CFDictionary) -> OSStatus
}

final class SystemKeychainClient: KeychainClient {
    func add(_ query: CFDictionary) -> OSStatus {
        SecItemAdd(query, nil)
    }

    func copyMatching(
        _ query: CFDictionary,
        _ item: UnsafeMutablePointer<CFTypeRef?>?
    ) -> OSStatus {
        SecItemCopyMatching(query, item)
    }

    func delete(_ query: CFDictionary) -> OSStatus {
        SecItemDelete(query)
    }
}
