//
//  API Service + Dependencies.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import Foundation

struct Domain {
    static let url = "https://fakestoreapi.com/products"
}

extension Domain {
    static func baseUrl() -> String {
        return url
    }
}

enum EndPoint {
    case getCategoryAndProduct
    
    var path: String {
        switch self {
        case .getCategoryAndProduct:
            return "\(Domain.baseUrl())"
        }
    }
}
