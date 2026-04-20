//
//  UpdateDiscoNameUseCase.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation

struct UpdateDiscoNameInput: Equatable {
    let disco: DiscoSummary
    let newName: String
}

typealias UpdateDiscoNameUseCaseInput = UpdateDiscoNameInput
typealias UpdateDiscoNameUseCaseOutput = DiscoSummary

protocol UpdateDiscoNameUseCase {
    func updateName(
        _ input: UpdateDiscoNameUseCaseInput,
        completion: @escaping (Result<UpdateDiscoNameUseCaseOutput, Error>) -> Void
    )
}
