//
//  AlbumReferenceEntity+CoreDataProperties.swift
//  Domain
//
//  Created by Thiago Henrique on 12/12/23.
//
//

import Foundation
import CoreData


extension AlbumReferenceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumReferenceEntity> {
        return NSFetchRequest<AlbumReferenceEntity>(entityName: "AlbumReferenceEntity")
    }

    @NSManaged public var artist: String?
    @NSManaged public var coverImage: String?
    @NSManaged public var name: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var profile: DiscoProfileEntity?

}

extension AlbumReferenceEntity : Identifiable {

}
