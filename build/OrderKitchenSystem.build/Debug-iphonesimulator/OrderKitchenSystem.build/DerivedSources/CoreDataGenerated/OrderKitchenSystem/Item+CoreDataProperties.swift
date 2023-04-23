//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Hao Yu Yeh on 2023/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var unitPrice: Double
    @NSManaged public var uuid: UUID?
    @NSManaged public var belongedTo: Order?

}

extension Item : Identifiable {

}
