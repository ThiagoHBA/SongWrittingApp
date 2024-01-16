//
//  RecordEntity+CoreDataProperties.swift
//  Infra
//
//  Created by Thiago Henrique on 16/12/23.
//
//

import Foundation
import CoreData


extension RecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordEntity> {
        return NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
    }

    @NSManaged public var audio: URL?
    @NSManaged public var tag: String?
    @NSManaged public var section: SectionEntity?

}

extension RecordEntity : Identifiable {

}
