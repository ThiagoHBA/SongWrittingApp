//
//  LastFMReferenceSearchRepository.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation

final class LastFMReferenceSearchRepository: ReferenceSearchRepository {
    struct LastFMReferenceSearchSession {
        let keywords: String
        let pageSize: Int
        let nextPage: Int
        let hasMore: Bool
    }

    private let networkClient: NetworkClient
    private var session: LastFMReferenceSearchSession?
    private var activeRequestID: UUID?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        session = .init(
            keywords: input.keywords,
            pageSize: 10,
            nextPage: 1,
            hasMore: false
        )

        requestPage(1, completion: completion)
    }

    func loadMore(
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        guard let session else {
            completion(.failure(SearchReferencesUseCaseError.noActiveSearchSession))
            return
        }

        guard session.hasMore else {
            completion(.success(.init(references: [], hasMore: false)))
            return
        }

        requestPage(session.nextPage, completion: completion)
    }

    func reset() {
        session = nil
        activeRequestID = nil
    }

    private func requestPage(
        _ page: Int,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        guard let session else {
            completion(.failure(SearchReferencesUseCaseError.noActiveSearchSession))
            return
        }

        let endpoint = GetLastFMReferencesEndpoint(
            keywords: session.keywords,
            limit: session.pageSize,
            page: page
        )
        let requestID = UUID()
        activeRequestID = requestID

        networkClient.makeRequest(endpoint) { [weak self] result in
            guard let self,
                  self.activeRequestID == requestID else {
                return
            }

            switch result {
            case .success(let data):
                do {
                    let dto = try LastFMAlbumReferenceDTO.loadFromData(data)
                    let pageResult = dto.mapPage()

                    self.activeRequestID = nil
                    self.session = LastFMReferenceSearchSession(
                        keywords: session.keywords,
                        pageSize: session.pageSize,
                        nextPage: page + 1,
                        hasMore: pageResult.hasMore
                    )

                    completion(.success(pageResult))
                } catch {
                    self.activeRequestID = nil
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                self.activeRequestID = nil
                completion(.failure(error))
            }
        }
    }
}
