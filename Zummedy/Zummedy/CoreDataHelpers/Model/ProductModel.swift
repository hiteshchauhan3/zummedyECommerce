//
//  ProductModel.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import Foundation
/// Model from api
class ProductData: Codable {
    var id: Int?
    var title: String?
    var price: Double?
    var alarmDataClassDescription: String?
    var category: Category?
    var image: String?
    var isBookMark = false
    var count = 0

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case alarmDataClassDescription
        case category, image
    }

    init(id: Int?, title: String?, price: Double?, alarmDataClassDescription: String?, category: Category?, image: String?) {
        self.id = id
        self.title = title
        self.price = price
        self.alarmDataClassDescription = alarmDataClassDescription
        self.category = category
        self.image = image
    }
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}
