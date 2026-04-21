//
//  ReferenceSearchStrategyRegistry.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation

final class ReferenceSearchStrategyRegistry: ReferenceSearchRepository {
    private let spotify: SearchReferencesUseCase
    private let lastFM: SearchReferencesUseCase
    private var activeStrategy: SearchReferencesUseCase?

    init(
        spotify: SearchReferencesUseCase,
        lastFM: SearchReferencesUseCase
    ) {
        self.spotify = spotify
        self.lastFM = lastFM
    }

    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        let strategy = strategy(for: input.provider)
        activeStrategy = strategy
        strategy.search(input, completion: completion)
    }

    func loadMore(
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        guard let activeStrategy else {
            completion(.failure(SearchReferencesUseCaseError.noActiveSearchSession))
            return
        }

        activeStrategy.loadMore(completion: completion)
    }

    func reset() {
        spotify.reset()
        lastFM.reset()
        activeStrategy = nil
    }

    private func strategy(for provider: ReferenceProvider) -> SearchReferencesUseCase {
        switch provider {
        case .spotify:
            spotify
        case .lastFM:
            lastFM
        }
    }
}
