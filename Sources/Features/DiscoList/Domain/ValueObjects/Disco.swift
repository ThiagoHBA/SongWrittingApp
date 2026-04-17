//
//  Disco.swift
//  Main
//
//  Created by Thiago Henrique on 17/04/26.
//

import Foundation

struct Disco: Equatable {
    let name: String
    let image: Data
    
    init(name: String, image: Data) throws {
        if name.isEmpty {
            throw DiscoListError.CreateDiscoError.emptyName
        }

        if image.isEmpty {
            throw DiscoListError.CreateDiscoError.emptyImage
        }
        
        self.name = name
        self.image = image
    }
}
