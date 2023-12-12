//
//  DiscoProfileEntity+CoreDataProperties.swift
//  Domain
//
//  Created by Thiago Henrique on 12/12/23.
//
//

import Foundation
import CoreData

extension DiscoProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiscoProfileEntity> {
        return NSFetchRequest<DiscoProfileEntity>(entityName: "DiscoProfileEntity")
    }

    @NSManaged public var disco: DiscoEntity?
    @NSManaged public var references: NSSet?
    @NSManaged public var sections: NSSet?

}

// MARK: Generated accessors for references
extension DiscoProfileEntity {

    @objc(addReferencesObject:)
    @NSManaged public func addToReferences(_ value: AlbumReferenceEntity)

    @objc(removeReferencesObject:)
    @NSManaged public func removeFromReferences(_ value: AlbumReferenceEntity)

    @objc(addReferences:)
    @NSManaged public func addToReferences(_ values: NSSet)

    @objc(removeReferences:)
    @NSManaged public func removeFromReferences(_ values: NSSet)

}

// MARK: Generated accessors for sections
extension DiscoProfileEntity {

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: SectionEntity)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: SectionEntity)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)

}

extension DiscoProfileEntity: Identifiable {

}
