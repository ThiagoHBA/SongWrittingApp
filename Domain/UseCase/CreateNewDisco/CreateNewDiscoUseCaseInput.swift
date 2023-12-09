//
//  CreateNewDiscoUseCaseInput.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct CreateNewDiscoUseCaseInput {
    public let name: String
    public let image: String
    
    public init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
