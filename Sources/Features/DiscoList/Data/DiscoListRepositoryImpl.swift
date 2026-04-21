import Foundation

private enum DiscoListRepositoryError: LocalizedError {
    case nameAlreadyExists
    case deleteNotImplemented

    var errorDescription: String? {
        switch self {
        case .nameAlreadyExists:
            return "Um disco com o mesmo nome já foi criado"
        case .deleteNotImplemented:
            return "A exclusão de discos ainda não foi migrada para a nova arquitetura"
        }
    }
}

final class DiscoListRepositoryImpl: DiscoListRepository {
    private let store: DiscoStore

    init(store: DiscoStore) {
        self.store = store
    }

    func load(
        _ input: GetDiscosUseCaseInput,
        completion: @escaping (Result<GetDiscosUseCaseOutput, Error>) -> Void
    ) {
        store.getDiscos { result in
            switch result {
            case .success(let discos):
                completion(.success(discos.map(DiscoListStoreMapper.discoSummary(from:))))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func create(
        _ input: CreateNewDiscoUseCaseInput,
        completion: @escaping (Result<CreateNewDiscoUseCaseOutput, Error>) -> Void
    ) {
        store.getDiscos { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let discos):
                if discos.contains(where: { $0.name == input.name }) {
                    completion(.failure(DiscoListRepositoryError.nameAlreadyExists))
                    return
                }

                let disco = DiscoStoreRecord(
                    id: UUID(),
                    name: input.name,
                    description: input.description,
                    coverImage: input.image
                )

                self.store.createDisco(disco) { createResult in
                    switch createResult {
                    case .success(let createdDisco):
                        completion(.success(DiscoListStoreMapper.discoSummary(from: createdDisco)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func delete(
        _ input: DeleteDiscoUseCaseInput,
        completion: @escaping (Result<DeleteDiscoUseCaseOutput, Error>) -> Void
    ) {
        let record = DiscoStoreRecord(
            id: input.disco.id,
            name: input.disco.name,
            coverImage: input.disco.coverImage
        )
        store.deleteDisco(record) { result in
            switch result {
            case .success:
                completion(.success(input.disco))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
