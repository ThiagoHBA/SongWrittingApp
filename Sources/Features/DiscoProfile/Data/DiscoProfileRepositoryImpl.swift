import Foundation

private enum DiscoProfileRepositoryError: LocalizedError {
    case cantFindDisco
    case cantFindSection

    var errorDescription: String? {
        switch self {
        case .cantFindDisco:
            return "Não foi possível encontrar o disco desejado para completar as operações"
        case .cantFindSection:
            return "Não foi possível encontrar a sessão para adição da gravação"
        }
    }
}

final class DiscoProfileRepositoryImpl: DiscoProfileRepository {
    private let store: DiscoStore

    init(store: DiscoStore) {
        self.store = store
    }

    func loadProfile(
        for disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        store.getProfiles { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profiles):
                if let profile = profiles.first(where: { $0.disco.id == disco.id }) {
                    completion(.success(DiscoProfileStoreMapper.profile(from: profile)))
                    return
                }

                let newProfile = DiscoProfileStoreRecord(
                    disco: DiscoProfileStoreMapper.storeDisco(from: disco),
                    references: [],
                    section: []
                )

                self.store.createProfile(newProfile) { createResult in
                    switch createResult {
                    case .success(let profile):
                        completion(.success(DiscoProfileStoreMapper.profile(from: profile)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addReferences(
        _ references: [AlbumReference],
        to disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        mutateProfile(for: disco, completion: completion) { profile in
            var profile = profile
            profile.references = references
            return profile
        }
    }

    func addSection(
        _ section: Section,
        to disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        mutateProfile(for: disco, completion: completion) { profile in
            var profile = profile
            profile.section.append(section)
            return profile
        }
    }

    func addRecord(
        in disco: DiscoSummary,
        to section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        mutateProfile(for: disco, completion: completion) { profile in
            guard let sectionIndex = profile.section.firstIndex(
                where: { $0.identifer == section.identifer }
            ) else {
                throw DiscoProfileRepositoryError.cantFindSection
            }

            var profile = profile
            profile.section[sectionIndex] = section
            return profile
        }
    }

    private func mutateProfile(
        for disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void,
        transform: @escaping (DiscoProfile) throws -> DiscoProfile
    ) {
        loadProfile(for: disco) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                do {
                    let updatedProfile = try transform(profile)
                    let storeRecord = DiscoProfileStoreMapper.storeProfile(from: updatedProfile)
                    self.store.updateProfile(storeRecord) { updateResult in
                        switch updateResult {
                        case .success(let updatedStoreRecord):
                            completion(.success(DiscoProfileStoreMapper.profile(from: updatedStoreRecord)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
