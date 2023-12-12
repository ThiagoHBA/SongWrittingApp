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
        container.loadPersistentStores { (_, error) in
            if let error = error { return }
        }
        
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
                let disco = Disco(
                    id: discoEntity.id ?? UUID(),
                    name: discoEntity.name ?? "",
                    coverImage: discoEntity.coverImage ?? Data()
                )
                completion(.success(disco))
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
                    Disco(
                        id: discoEntity.id ?? UUID(),
                        name: discoEntity.name ?? "",
                        coverImage: discoEntity.coverImage ?? Data()
                    )
                }
                completion(.success(discos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func loadProfile(for disco: Disco, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
//         let managedObjectContext = persistentContainer.viewContext
//         managedObjectContext.perform {
//             do {
//                 guard let discoEntity = try self.fetchDiscoEntity(with: disco.id, in: managedObjectContext) else {
//                     throw NSError(domain: "Data not found", code: 404, userInfo: nil)
//                 }
//                 
//                 let discoProfile = self.createDiscoProfile(from: discoEntity)
//                 completion(.success(discoProfile))
//             } catch {
//                 completion(.failure(error))
//             }
//         }
     }
     
    public func updateDiscoReferences(_ disco: Disco, references: [AlbumReference], completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
//         let managedObjectContext = persistentContainer.viewContext
//         managedObjectContext.perform {
//             do {
//                 guard let discoEntity = try self.fetchDiscoEntity(with: disco.id, in: managedObjectContext) else {
//                     throw NSError(domain: "Data not found", code: 404, userInfo: nil)
//                 }
//                 
//                 // Update references for the discoEntity here...
//                 // For example:
//                 // discoEntity.references = references.map { createAlbumReferenceEntity(from: $0, in: managedObjectContext) }
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
     
//     private func fetchDiscoEntity(with id: UUID, in context: NSManagedObjectContext) throws -> DiscoEntity? {
//         // Implement fetching logic based on the provided id
//         // Return the corresponding DiscoEntity if found, otherwise return nil
//         // Example:
//         let fetchRequest: NSFetchRequest<DiscoEntity> = DiscoEntity.fetchRequest()
//         fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//         return try context.fetch(fetchRequest).first
//     }
     
     // Other helper methods to create entities and construct DiscoProfile from entities
     
//     private func createDiscoProfile(from discoEntity: DiscoEntity) -> DiscoProfile {
//         let disco = Disco(
//            id: discoEntity.id ?? UUID(),
//            name: discoEntity.name ?? "",
//            coverImage: discoEntity.coverImage ?? Data()
//         )
//         let references = discoEntity.references?.compactMap { /* create AlbumReference from AlbumReferenceEntity */ } ?? []
//         let sections = discoEntity.sections?.compactMap { /* create Section from SectionEntity */ } ?? []
//         
//         return DiscoProfile(disco: disco, references: references, section: sections)
//     }
}
