//
//  AddDiscoNewReferenceInput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public struct AddDiscoNewReferenceInput {
    public let disco: Disco
    public let newReferences: [AlbumReference]

    public init(disco: Disco, newReferences: [AlbumReference]) {
        self.disco = disco
        self.newReferences = newReferences
    }
}
