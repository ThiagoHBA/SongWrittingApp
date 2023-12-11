//
//  AddDiscoNewReferenceUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public protocol AddDiscoNewReferenceUseCaseOutput {
    func successfullyAddNewReferences(to disco: Disco, references: [AlbumReference])
    func errorWhileAddingNewReferences(_ error: Error)
}
