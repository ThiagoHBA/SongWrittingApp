//
//  DataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

protocol DataEntity {
    static func loadFromData(_ data: Data) throws -> Self
}

extension DataEntity where Self : Decodable {
    static func loadFromData(_ data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
}
