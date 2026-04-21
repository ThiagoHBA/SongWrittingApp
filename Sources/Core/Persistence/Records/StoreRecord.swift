//
//  StoreRecord.swift
//  Main
//
//  Created by Thiago Henrique on 17/04/26.
//

import Foundation

public protocol StoreRecord {
    static func loadFromData(_ data: Data) throws -> Self
}

public extension StoreRecord where Self: Decodable {
    static func loadFromData(_ data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
