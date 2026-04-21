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
    private let fileManagerService: FileManagerService

    init(store: DiscoStore, fileManagerService: FileManagerService) {
        self.store = store
        self.fileManagerService = fileManagerService
    }

    func load(
        _ input: GetDiscoProfileUseCaseInput,
        completion: @escaping (Result<GetDiscoProfileUseCaseOutput, Error>) -> Void
    ) {
        store.getProfiles { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profiles):
                if let profile = profiles.first(where: { $0.disco.id == input.id }) {
                    completion(.success(DiscoProfileStoreMapper.profile(from: profile)))
                    return
                }

                let newProfile = DiscoProfileStoreRecord(
                    disco: DiscoProfileStoreMapper.storeDisco(from: input),
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
        _ input: AddDiscoNewReferenceUseCaseInput,
        completion: @escaping (Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void
    ) {
        mutateProfile(for: input.disco, completion: completion) { profile in
            var profile = profile
            profile.references = input.newReferences
            return profile
        }
    }

    func addSection(
        _ input: AddNewSectionToDiscoUseCaseInput,
        completion: @escaping (Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void
    ) {
        mutateProfile(for: input.disco, completion: completion) { profile in
            var profile = profile
            profile.section.append(input.section)
            return profile
        }
    }

    func addRecord(
        _ input: AddNewRecordToSessionUseCaseInput,
        completion: @escaping (Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void
    ) {
        mutateProfile(for: input.disco, completion: completion) { profile in
            guard let sectionIndex = profile.section.firstIndex(
                where: { $0.identifer == input.sectionIdentifier }
            ) else {
                throw DiscoProfileRepositoryError.cantFindSection
            }

            let persistedAudioURL = try self.fileManagerService.persistFile(at: input.audioFileURL)
            var profile = profile
            profile.section[sectionIndex].records.append(
                Record(tag: .custom(""), audio: persistedAudioURL)
            )
            return profile
        }
    }

    func updateName(
        _ input: UpdateDiscoNameUseCaseInput,
        completion: @escaping (Result<UpdateDiscoNameUseCaseOutput, Error>) -> Void
    ) {
        let updatedRecord = DiscoStoreRecord(
            id: input.disco.id,
            name: input.newName,
            description: input.disco.description,
            coverImage: input.disco.coverImage
        )
        store.updateDisco(updatedRecord) { result in
            switch result {
            case .success(let record):
                completion(.success(DiscoSummary(
                    id: record.id,
                    name: record.name,
                    description: record.description,
                    coverImage: record.coverImage
                )))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteRecord(
        _ input: DeleteRecordUseCaseInput,
        completion: @escaping (Result<DeleteRecordUseCaseOutput, Error>) -> Void
    ) {
        mutateProfile(for: input.disco, completion: completion) { profile in
            guard let sectionIndex = profile.section.firstIndex(where: { $0.identifer == input.sectionIdentifier }) else {
                throw DiscoProfileRepositoryError.cantFindSection
            }
            var profile = profile
            profile.section[sectionIndex].records.removeAll { $0.audio == input.audioURL }
            return profile
        }
    }

    func deleteSection(
        _ input: DeleteSectionUseCaseInput,
        completion: @escaping (Result<DeleteSectionUseCaseOutput, Error>) -> Void
    ) {
        mutateProfile(for: input.disco, completion: completion) { profile in
            var profile = profile
            profile.section.removeAll { $0.identifer == input.sectionIdentifier }
            return profile
        }
    }

    func loadReferences(
        _ input: GetDiscoReferencesUseCaseInput,
        completion: @escaping (Result<GetDiscoReferencesUseCaseOutput, Error>) -> Void
    ) {
        load(input) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile.references))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func delete(
        _ input: DeleteDiscoUseCaseInput,
        completion: @escaping (Result<DeleteDiscoUseCaseOutput, Error>) -> Void
    ) {
        let record = DiscoProfileStoreMapper.storeDisco(from: input.disco)
        store.deleteDisco(record) { result in
            switch result {
            case .success:
                completion(.success(input.disco))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func mutateProfile(
        for disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void,
        transform: @escaping (DiscoProfile) throws -> DiscoProfile
    ) {
        load(disco) { [weak self] result in
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
