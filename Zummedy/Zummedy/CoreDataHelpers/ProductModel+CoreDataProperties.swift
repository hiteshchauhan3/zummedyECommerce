//
//  ProductModel+CoreDataProperties.swift
//  DynamicPopup
//
//  Created by Hitesh on 12/07/21.
//
//

import Foundation
import CoreData


extension ProductModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductModel> {
        return NSFetchRequest<ProductModel>(entityName: "ProductModel")
    }

    @NSManaged public var id: Int16
    @NSManaged public var productDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var category: String?
    @NSManaged public var img: Data?
    @NSManaged public var isBookmark: Bool
    @NSManaged public var itemsCount: Int16

}

extension ProductModel : Identifiable {

}
