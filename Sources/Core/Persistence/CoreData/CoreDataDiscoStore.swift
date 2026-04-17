//
//  CoreDataDiscoStorage.swift
//  Infra
//
//  Created by Thiago Henrique on 16/12/23.
//

import Foundation
import CoreData

public final class CoreDataDiscoStore: DiscoStore {
    private let persistentContainer: NSPersistentContainer
    
    public init() throws {
        let modelName = DiscoStoreConstants.modelName
        
        guard let modelURL = Bundle(for: type(of: self)).url(
            forResource: modelName,
            withExtension: DiscoStoreConstants.modelExtension
        ) else { throw StorageError.cantFindModel }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            throw StorageError.cantFindModel
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: mom)
        container.loadPersistentStores { (_, error) in if error == nil { return } }
        
        self.persistentContainer = container
    }
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    public func createDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<DiscoStoreRecord, Error>) -> Void
    ) {
        
    }
    
    public func getDiscos(
        completion: @escaping (Result<[DiscoStoreRecord], Error>) -> Void
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
    
    public func getProfiles(
        completion: @escaping (Result<[DiscoProfileStoreRecord], Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DiscoProfileEntity> = DiscoProfileEntity.fetchRequest()
        managedObjectContext.perform {
            do {
                let discoProfiles = try fetchRequest.execute()
                let profilesDataEntity = discoProfiles.map {
                    self.createDiscoProfile(from: $0)
                }
                completion(.success(profilesDataEntity))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func createProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.perform {
            do {
                let newProfileEntity = DiscoProfileEntity(context: managedObjectContext)
                guard let discoEntity = try self.fetchDiscoEntity(
                    with: profile.disco.id,
                    in: managedObjectContext
                ) else {
                    completion(.failure(StorageError.cantLoadDisco))
                    return
                }
                newProfileEntity.disco = discoEntity
                newProfileEntity.references = NSSet(array: [])
                newProfileEntity.sections = NSSet(array: [])
                
                try managedObjectContext.save()
                completion(.success(self.createDiscoProfile(from: newProfileEntity)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func updateProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DiscoProfileEntity> = DiscoProfileEntity.fetchRequest()
        managedObjectContext.perform {
            do {
                var discoProfiles = try fetchRequest.execute()
                let profiles = discoProfiles.map { discoEntity in
                    self.createDiscoProfile(from: discoEntity)
                }
                guard let profileIndex = profiles.firstIndex(where: {
                    $0.disco.id == profile.disco.id
                }) else {
                    completion(.failure(StorageError.cantLoadProfile))
                    return
                }
                
                let updatedEntity = DiscoProfileEntity(context: managedObjectContext)
                let discoEntity = try self.fetchDiscoEntity(with: profile.disco.id, in: managedObjectContext)
                let updatedSections = profile.section.map {
                    self.createSectionEntity($0, in: managedObjectContext)
                }
                updatedEntity.disco = discoEntity
                updatedEntity.references = NSSet(array: [])
                updatedEntity.sections = NSSet(array: updatedSections)
                
                discoProfiles[profileIndex] = updatedEntity
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        
    }
    
    
}

extension CoreDataDiscoStore {
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
    
    private func createEmptyDiscoProfile(
        from discoEntity: DiscoEntity
    ) -> DiscoProfileStoreRecord {
        let disco = DiscoStoreRecord(
            id: discoEntity.id ?? UUID(),
            name: discoEntity.name ?? "",
            coverImage: discoEntity.coverImage ?? Data()
        )
        return DiscoProfileStoreRecord(
            disco: disco,
            references: .init(albums: .init(items: [])),
            section: []
        )
    }
    
    private func createDiscoProfile(
        from discoProfileEntity: DiscoProfileEntity
    ) -> DiscoProfileStoreRecord {
        let disco = createDisco(from: discoProfileEntity.disco!)
        let references = (
            discoProfileEntity.references?.allObjects as? [AlbumReferenceEntity] ?? []
        ).map {
            createAlbumReference(from: $0)
        }
        
        var sectionEntities = discoProfileEntity.sections?.allObjects as? [SectionEntity]
        sectionEntities?.sort(by: { $0.index < $1.index })
        let sections = (sectionEntities ?? []).map { createSection(from: $0) }
        
        return DiscoProfileStoreRecord(
            disco: disco,
            references: .init(albums: .init(items: [])),
            section: sections
        )
    }
    
    private func createDisco(from discoEntity: DiscoEntity) -> DiscoStoreRecord {
        return DiscoStoreRecord(
            id: discoEntity.id ?? UUID(),
            name: discoEntity.name ?? "",
            coverImage: discoEntity.coverImage ?? Data()
        )
    }
    
    private func createSection(from sectionEntity: SectionEntity) -> SectionStoreRecord {
        let records = (sectionEntity.records?.allObjects as? [RecordEntity] ?? []).map { createRecord(from: $0) }
        
        return SectionStoreRecord(
            identifer: sectionEntity.identifier ?? "",
            records: records
        )
    }
    
    private func createRecord(from recordEntity: RecordEntity) -> RecordStoreRecord {
        return RecordStoreRecord(
            tag:  InstrumentTagStoreRecord.custom(recordEntity.tag ?? ""),
            audio: recordEntity.audio!
        )
    }
    
    private func createAlbumReference(
        from albumEntity: AlbumReferenceEntity
    ) -> AlbumReferenceStoreRecord {
        
        return AlbumReferenceStoreRecord(albums: .init(items: []))
    }
    
    private func createAlbumReferenceEntity(
        from albumReference: AlbumReferenceStoreRecord,
        in context: NSManagedObjectContext
    ) -> AlbumReferenceEntity {
        //        let albumReferenceEntity = AlbumReferenceEntity(context: context)
        //        albumReferenceEntity.name = albumReference.name
        //        albumReferenceEntity.artist = albumReference.artist
        //        albumReferenceEntity.releaseDate = albumReference.releaseDate
        //        albumReferenceEntity.coverImage = albumReference.coverImage
        
        return .init()
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
    
    private func createSectionEntity(
        _ section: SectionStoreRecord,
        in context: NSManagedObjectContext
    ) -> SectionEntity {
        var sectionEntity = SectionEntity(context: context)
        sectionEntity.identifier = section.identifer
        sectionEntity.records = NSSet(array: section.records.map { createRecordEntity(from: $0, in: context)})
        
        return sectionEntity
    }
    
    private func createRecordEntity(
        from data: RecordStoreRecord,
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
