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
        let modelName = "SongWrittingApp"
        
        guard let modelURL = Bundle(for: type(of: self)).url(
            forResource: modelName,
            withExtension:"momd"
        ) else { throw DataError.loadModelError }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            throw DataError.loadModelError
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: mom)
        container.loadPersistentStores { (_, error) in if let _ = error { return } }
        
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
    
    public func loadDiscos(completion: @escaping (Result<[Disco], Error>) -> Void) {
        let managedObjectContext = persistentContainer.viewContext
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
    
    public func loadProfile(for disco: Disco, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
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
     
    public func updateDiscoReferences(_ disco: Disco, references: [AlbumReference], completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
         let managedObjectContext = persistentContainer.viewContext
         managedObjectContext.perform {
             do {
                 guard let discoProfile = try self.fetchDiscoProfileEntity(with: disco.id, in: managedObjectContext) else {
                     completion(.failure(DataError.cantFindDisco))
                     return
                 }
                 let albumReferenceEntities = references.map { reference in
                     return self.createAlbumReferenceEntity(from: reference, in: managedObjectContext)
                 }
                 discoProfile.references = NSSet(array: albumReferenceEntities)
                 
                 try managedObjectContext.save()
                 let updatedDiscoProfile = self.createDiscoProfile(from: discoProfile)
                 completion(.success(updatedDiscoProfile))
             } catch {
                 completion(.failure(error))
             }
         }
     }
     
    public func addNewSection(_ disco: Disco, _ section: Section, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
//         let managedObjectContext = persistentContainer.viewContext
//         managedObjectContext.perform {
//             do {
//                 guard let discoEntity = try self.fetchDiscoEntity(with: disco.id, in: managedObjectContext) else {
//                     throw NSError(domain: "Data not found", code: 404, userInfo: nil)
//                 }
//                 
//                 let sectionEntity = SectionEntity(context: managedObjectContext)
//                 sectionEntity.identifier = section.identifer
//                 let record = RecordEntity(entity: sectionEntity, insertInto: managedObjectContext)
//                 record.tag = section.records
//                 
//                 
//                 discoEntity.addToSections(sectionEntity)
//                 
//                 try managedObjectContext.save()
//                 
//                 let updatedDiscoProfile = self.createDiscoProfile(from: discoEntity)
//                 completion(.success(updatedDiscoProfile))
//             } catch {
//                 completion(.failure(error))
//             }
//         }
     }
     
    public func addNewRecord(_ disco: Disco, _ section: Section, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
//         let managedObjectContext = persistentContainer.viewContext
//         managedObjectContext.perform {
//             do {
//                 guard let discoEntity = try self.fetchDiscoEntity(with: disco.id, in: managedObjectContext),
//                       let sectionEntity = self.findSectionEntity(with: section.identifer, in: discoEntity) else {
//                     throw NSError(domain: "Data not found", code: 404, userInfo: nil)
//                 }
//                 
//                 // Create a new RecordEntity and associate it with the sectionEntity
//                 let recordEntity = self.createRecordEntity(from: section.records.first!, in: managedObjectContext) // Assuming the method takes the first record from the section
//                 sectionEntity.addToRecords(recordEntity)
//                 
//                 try managedObjectContext.save()
//                 
//                 let updatedDiscoProfile = self.createDiscoProfile(from: discoEntity)
//                 completion(.success(updatedDiscoProfile))
//             } catch {
//                 completion(.failure(error))
//             }
//         }
     }
     
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
        let references = (discoProfileEntity.references?.allObjects as? [AlbumReferenceEntity] ?? []).map { createAlbumReference(from: $0) }
        let sections = (discoProfileEntity.sections?.allObjects as? [SectionEntity] ?? []).map { createSection(from: $0) }
        
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
}
