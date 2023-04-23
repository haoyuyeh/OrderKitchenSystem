//
//  Catagory+CoreDataProperties.swift
//  
//
//  Created by Hao Yu Yeh on 2023/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Catagory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catagory> {
        return NSFetchRequest<Catagory>(entityName: "Catagory")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Catagory {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Option)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Option)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

}

extension Catagory : Identifiable {

}
