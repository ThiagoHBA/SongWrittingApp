//
//  KeychainClientMock.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import Security
@testable import Main

final class KeychainClientMock: KeychainClient {
    private(set) var addedQuery: CFDictionary?
    private(set) var copiedQuery: CFDictionary?
    private(set) var deletedQuery: CFDictionary?

    var addStatus: OSStatus = errSecSuccess
    var copyMatchingStatus: OSStatus = errSecSuccess
    var deleteStatus: OSStatus = errSecSuccess
    var copiedItem: CFTypeRef?

    func add(_ query: CFDictionary) -> OSStatus {
        addedQuery = query
        return addStatus
    }

    func copyMatching(
        _ query: CFDictionary,
        _ item: UnsafeMutablePointer<CFTypeRef?>?
    ) -> OSStatus {
        copiedQuery = query
        item?.pointee = copiedItem
        return copyMatchingStatus
    }

    func delete(_ query: CFDictionary) -> OSStatus {
        deletedQuery = query
        return deleteStatus
    }
}
