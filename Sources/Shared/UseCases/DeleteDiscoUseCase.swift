//
//  DeleteDiscoUseCase.swift
//  Main
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation

struct DeleteDiscoUseCaseInput: Equatable {
    let disco: DiscoSummary
}

typealias DeleteDiscoUseCaseOutput = DiscoSummary

protocol DeleteDiscoUseCase {
    func delete(
        _ input: DeleteDiscoUseCaseInput,
        completion: @escaping (Result<DeleteDiscoUseCaseOutput, Error>) -> Void
    )
}
