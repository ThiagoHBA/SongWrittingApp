//
//  DiscoServiceFromStorage.swift
//  Data
//
//  Created by Thiago Henrique on 12/12/23.
//
//
import Foundation
import Domain
import CoreData

public final class DiscoServiceFromStorage: DiscoService {
    private let persistentContainer: NSPersistentContainer

    public init() throws {
        let modelName = DiscoServiceFromStorageConstants.modelName

        guard let modelURL = Bundle(for: type(of: self)).url(
            forResource: modelName,
            withExtension: DiscoServiceFromStorageConstants.modelExtension
        ) else { throw DataError.loadModelError }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            throw DataError.loadModelError
        }

        let container = NSPersistentContainer(name: modelName, managedObjectModel: mom)
        container.loadPersistentStores { (_, error) in if error == nil { return } }

        self.persistentContainer = container
    }

    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    public func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<Disco, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.perform {
            let discoEntity = DiscoEntity(context: managedObjectContext)
            discoEntity.id = UUID()
            discoEntity.name = name
            discoEntity.coverImage = image

            do {
                try managedObjectContext.save()
                completion(.success(self.createDisco(from: discoEntity)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func loadDiscos(
        completion: @escaping (Result<[Disco], Error>) -> Void
    ) {
        let managedObjectContext = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DiscoEntity> = DiscoEntity.fetchRequest()

        managedObjectContext.perform {
            do {
                let discoEntities = try fetchRequest.execute()
                let discos = discoEntities.map { discoEntity in
                    self.createDisco(from: discoEntity)
                }
                completion(.success(discos))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func loadProfile(
        for disco: Disco,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.perform {
            do {
                guard let discoEntity = try self.fetchDiscoEntity(
                    with: disco.id,
                    in: managedObjectContext
                ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }

                guard let discoProfile = try self.fetchDiscoProfileEntity(
                    with: disco.id,
                    in: managedObjectContext
                ) else {
                    let newProfileEntity = DiscoProfileEntity(context: managedObjectContext)
                    newProfileEntity.disco = discoEntity
                    newProfileEntity.references = NSSet(array: [])
                    newProfileEntity.sections = NSSet(array: [])

                    try managedObjectContext.save()
                    completion(.success(self.createDiscoProfile(from: newProfileEntity)))
                    return
                }
                completion(.success(self.createDiscoProfile(from: discoProfile)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func updateDiscoReferences(
        _ disco: Disco,
        references: [AlbumReference],
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.perform {
            do {
                guard let discoProfile = try self.fetchDiscoProfileEntity(
                    with: disco.id,
                    in: managedObjectContext
                ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }
                var existingReferences = discoProfile.references?.allObjects as? [AlbumReferenceEntity] ?? []

                let newAlbumReferenceEntities = references.map { reference in
                    return self.createAlbumReferenceEntity(from: reference, in: managedObjectContext)
                }

                let newReferencesUnrepeated = newAlbumReferenceEntities.compactMap { reference in
                    if !existingReferences.contains(where: { $0.name == reference.name }) {
                        return reference
                    }
                    return nil
                }

                existingReferences.append(contentsOf: newReferencesUnrepeated)
                discoProfile.references = NSSet(array: existingReferences)

                try managedObjectContext.save()
                let updatedDiscoProfile = self.createDiscoProfile(from: discoProfile)
                completion(.success(updatedDiscoProfile))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func addNewSection(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.perform {
            do {
                guard let discoProfile = try self.fetchDiscoProfileEntity(
                    with: disco.id,
                    in: managedObjectContext
                ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }

                let sectionEntity = SectionEntity(context: managedObjectContext)
                sectionEntity.identifier = section.identifer
                sectionEntity.index = Int16(discoProfile.sections?.count ?? 0)
                sectionEntity.records = NSSet(
                    array: section.records.map {
                        self.createRecordEntity(from: $0, in: managedObjectContext)
                    }
                )

                discoProfile.addToSections(sectionEntity)

                try managedObjectContext.save()
                let updatedDiscoProfile = self.createDiscoProfile(from: discoProfile)
                completion(.success(updatedDiscoProfile))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func addNewRecord(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.perform {
            do {
                guard let discoProfile = try self.fetchDiscoProfileEntity(with: disco.id, in: managedObjectContext),
                      let sectionEntity = self.findSectionEntity(
                        with: section.identifer,
                        context: managedObjectContext
                      ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }

                let recordEntity = self.createRecordEntity(from: section.records.last!, in: managedObjectContext)
                sectionEntity.addToRecords(recordEntity)

                try managedObjectContext.save()
                let updatedDiscoProfile = self.createDiscoProfile(from: discoProfile)
                completion(.success(updatedDiscoProfile))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - HELPERS
extension DiscoServiceFromStorage {
    private func fetchDiscoEntity(
        with id: UUID,
        in context: NSManagedObjectContext
    ) throws -> DiscoEntity? {
        let fetchRequest: NSFetchRequest<DiscoEntity> = DiscoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(fetchRequest).first
    }

    private func fetchDiscoProfileEntity(
        with id: UUID,
        in context: NSManagedObjectContext
    ) throws -> DiscoProfileEntity? {
        let fetchRequest: NSFetchRequest<DiscoProfileEntity> = DiscoProfileEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "disco.id == %@", id as CVarArg)
        return try context.fetch(fetchRequest).first
    }

    private func createEmptyDiscoProfile(from discoEntity: DiscoEntity) -> DiscoProfile {
        let disco = Disco(
            id: discoEntity.id ?? UUID(),
            name: discoEntity.name ?? "",
            coverImage: discoEntity.coverImage ?? Data()
        )
        return DiscoProfile(disco: disco, references: [], section: [])
    }

    private func createDiscoProfile(from discoProfileEntity: DiscoProfileEntity) -> DiscoProfile {
        let disco = createDisco(from: discoProfileEntity.disco!)
        let references = (
            discoProfileEntity.references?.allObjects as? [AlbumReferenceEntity] ?? []
        ).map {
            createAlbumReference(from: $0)
        }

        var sectionEntities = discoProfileEntity.sections?.allObjects as? [SectionEntity]
        sectionEntities?.sort(by: { $0.index < $1.index })
        let sections = (sectionEntities ?? []).map { createSection(from: $0) }

        return DiscoProfile(disco: disco, references: references, section: sections)
    }

    private func createDisco(from discoEntity: DiscoEntity) -> Disco {
        return Disco(
            id: discoEntity.id ?? UUID(),
            name: discoEntity.name ?? "",
            coverImage: discoEntity.coverImage ?? Data()
        )
    }

    private func createSection(from sectionEntity: SectionEntity) -> Section {
        let records = (sectionEntity.records?.allObjects as? [RecordEntity] ?? []).map { createRecord(from: $0) }

        return Section(identifer: sectionEntity.identifier ?? "", records: records)
    }

    private func createRecord(from recordEntity: RecordEntity) -> Record {
        return Record(
            tag: InstrumentTag.custom(recordEntity.tag ?? ""),
            audio: recordEntity.audio!
        )
    }

    private func createAlbumReference(from albumEntity: AlbumReferenceEntity) -> AlbumReference {
        return AlbumReference(
            name: albumEntity.name ?? "",
            artist: albumEntity.artist ?? "",
            releaseDate: albumEntity.releaseDate ?? "",
            coverImage: albumEntity.coverImage ?? ""
        )
    }

    private func createAlbumReferenceEntity(
        from albumReference: AlbumReference,
        in context: NSManagedObjectContext
    ) -> AlbumReferenceEntity {
        let albumReferenceEntity = AlbumReferenceEntity(context: context)
        albumReferenceEntity.name = albumReference.name
        albumReferenceEntity.artist = albumReference.artist
        albumReferenceEntity.releaseDate = albumReference.releaseDate
        albumReferenceEntity.coverImage = albumReference.coverImage

        return albumReferenceEntity
    }

    private func findSectionEntity(with identifier: String, context: NSManagedObjectContext) -> SectionEntity? {
        let fetchRequest: NSFetchRequest<SectionEntity> = SectionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1

        do {
            let sections = try context.fetch(fetchRequest)
            return sections.first
        } catch {
            print("Error fetching SectionEntity: \(error)")
            return nil
        }
    }
    private func createRecordEntity(
        from data: Record,
        in context: NSManagedObjectContext
    ) -> RecordEntity {
        func convertTagToString() -> String {
            switch data.tag {
            case .guitar:
                return "Guitarra"
            case .vocal:
                return "Voz"
            case .drums:
                return "Bateria"
            case .bass:
                return "Baixo"
            case .custom(let value):
                return value
            }
        }
        let record = RecordEntity(context: context)
        record.tag = convertTagToString()
        record.audio = data.audio

        return record
    }
}
