//
//  Disco.swift
//  Main
//
//  Created by Thiago Henrique on 17/04/26.
//

import Foundation

struct Disco: Equatable {
    let name: String
    let description: String?
    let image: Data

    init(name: String, description: String? = nil, image: Data) throws {
        if name.isEmpty {
            throw DiscoListError.CreateDiscoError.emptyName
        }

        if image.isEmpty {
            throw DiscoListError.CreateDiscoError.emptyImage
        }

        self.name = name
        self.description = description
        self.image = image
    }
}
