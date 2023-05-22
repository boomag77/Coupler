//
//  WordEntity+CoreDataProperties.swift
//  
//
//  Created by Sergey on 5/17/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension WordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordEntity> {
        return NSFetchRequest<WordEntity>(entityName: "WordEntity")
    }

    @NSManaged public var addedDate: String?
    @NSManaged public var complexity: Float
    @NSManaged public var memorized: Bool
    @NSManaged public var name: String?
    @NSManaged public var storage: String?
    @NSManaged public var trainedCount: Int64
    @NSManaged public var wasRight: Int64
    @NSManaged public var wasWrong: Int64
    @NSManaged public var wordDescription: String?

}

extension WordEntity : Identifiable {

}
