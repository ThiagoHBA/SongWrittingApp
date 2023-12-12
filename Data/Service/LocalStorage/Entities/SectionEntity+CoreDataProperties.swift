//
//  SectionEntity+CoreDataProperties.swift
//  Domain
//
//  Created by Thiago Henrique on 12/12/23.
//
//

import Foundation
import CoreData


extension SectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionEntity> {
        return NSFetchRequest<SectionEntity>(entityName: "SectionEntity")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var index: Int16
    @NSManaged public var profile: DiscoProfileEntity?
    @NSManaged public var records: NSSet?

}

// MARK: Generated accessors for records
extension SectionEntity {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: RecordEntity)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: RecordEntity)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}

extension SectionEntity : Identifiable {

}
