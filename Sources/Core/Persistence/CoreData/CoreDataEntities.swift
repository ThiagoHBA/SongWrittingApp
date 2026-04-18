//
//  CoreDataEntities.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import CoreData
import Foundation

@objc(AlbumReferenceEntity)
final class AlbumReferenceEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<AlbumReferenceEntity> {
        NSFetchRequest<AlbumReferenceEntity>(entityName: "AlbumReferenceEntity")
    }

    @NSManaged var artist: String?
    @NSManaged var coverImage: String?
    @NSManaged var name: String?
    @NSManaged var releaseDate: String?
    @NSManaged var profile: DiscoProfileEntity?
}

@objc(DiscoEntity)
final class DiscoEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DiscoEntity> {
        NSFetchRequest<DiscoEntity>(entityName: "DiscoEntity")
    }

    @NSManaged var coverImage: Data?
    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var profile: DiscoProfileEntity?
}

@objc(DiscoProfileEntity)
final class DiscoProfileEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DiscoProfileEntity> {
        NSFetchRequest<DiscoProfileEntity>(entityName: "DiscoProfileEntity")
    }

    @NSManaged var disco: DiscoEntity?
    @NSManaged var references: NSSet?
    @NSManaged var sections: NSSet?
}

@objc(RecordEntity)
final class RecordEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<RecordEntity> {
        NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
    }

    @NSManaged var audio: URL?
    @NSManaged var tag: String?
    @NSManaged var section: SectionEntity?
}

@objc(SectionEntity)
final class SectionEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<SectionEntity> {
        NSFetchRequest<SectionEntity>(entityName: "SectionEntity")
    }

    @NSManaged var identifier: String?
    @NSManaged var index: Int16
    @NSManaged var profile: DiscoProfileEntity?
    @NSManaged var records: NSSet?
}
