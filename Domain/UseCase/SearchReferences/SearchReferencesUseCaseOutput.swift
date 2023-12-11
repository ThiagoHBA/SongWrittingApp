//
//  SearchReferencesUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public protocol SearchReferencesUseCaseOutput {
    func didFindedReferences(_ data: [AlbumReference])
    func errorWhileFindingReferences(_ error: Error)
}
