//
//  Option+CoreDataProperties.swift
//  
//
//  Created by Hao Yu Yeh on 2023/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Option {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option")
    }

    @NSManaged public var common: Bool
    @NSManaged public var commonSelected: Bool
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var unitPrice: Double
    @NSManaged public var uuid: UUID?
    @NSManaged public var catagory: Catagory?
    @NSManaged public var next: NSSet?
    @NSManaged public var previous: Option?

}

// MARK: Generated accessors for next
extension Option {

    @objc(addNextObject:)
    @NSManaged public func addToNext(_ value: Option)

    @objc(removeNextObject:)
    @NSManaged public func removeFromNext(_ value: Option)

    @objc(addNext:)
    @NSManaged public func addToNext(_ values: NSSet)

    @objc(removeNext:)
    @NSManaged public func removeFromNext(_ values: NSSet)

}

extension Option : Identifiable {

}
