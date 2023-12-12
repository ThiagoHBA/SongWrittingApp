//
//  DiscoEntity+CoreDataProperties.swift
//  Domain
//
//  Created by Thiago Henrique on 12/12/23.
//
//

import Foundation
import CoreData

extension DiscoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiscoEntity> {
        return NSFetchRequest<DiscoEntity>(entityName: "DiscoEntity")
    }

    @NSManaged public var coverImage: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var profile: DiscoProfileEntity?

}

extension DiscoEntity: Identifiable {

}
