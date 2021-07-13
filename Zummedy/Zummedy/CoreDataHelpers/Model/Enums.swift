//
//  Enums.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import Foundation

enum Failure: Error {
    case apiFailure
    case decodeFailure
    case dataAlreadyExists
    
    var message: String {
        switch self {
        case .apiFailure:
            return "Failed"
        case .decodeFailure:
            return "Something went wrong"
        case .dataAlreadyExists:
            return "Data already exists"
        }
    }
}

/// Enums for success and failure  value
enum CategoryAndProductResult<Value: Decodable> {
    case success(Value)
    case failure(Failure)
}

enum Result<Value: Decodable> {
    case success(Value)
    case failure(Int)
}

enum DefaultResult<Value: Decodable> {
    case success(Value)
    case failure(Failure)
}
