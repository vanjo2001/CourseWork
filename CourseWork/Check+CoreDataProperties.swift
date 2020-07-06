//
//  Check+CoreDataProperties.swift
//  
//
//  Created by IvanLyuhtikov on 6/12/20.
//
//

import Foundation
import CoreData


extension Check {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Check> {
        return NSFetchRequest<Check>(entityName: "Check")
    }

    @NSManaged public var allPrice: Double
    @NSManaged public var cash: Double
    @NSManaged public var change: Double
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension Check {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
