//
//  Product+CoreDataProperties.swift
//  
//
//  Created by IvanLyuhtikov on 6/7/20.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var descriptionc: String?
    @NSManaged public var firm: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var discount: Int16

}
