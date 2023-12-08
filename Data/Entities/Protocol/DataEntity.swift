//
//  DataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

protocol DataEntity {
    associatedtype Entity
    static func loadFromData(_ data: Data) throws -> Entity
}
