//
//  Order+CoreDataProperties.swift
//  
//
//  Created by Hao Yu Yeh on 2023/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var orderNumber: String?
    @NSManaged public var sum: Double
    @NSManaged public var uuid: UUID?
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Order {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Item)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Item)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

}

extension Order : Identifiable {

}
