//
//  Requestable.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import UIKit

typealias Handler = (Result<Data>) -> Void
typealias DefaultCallBack = (DefaultResult<Data>) -> Void
typealias ProductDataCallBack = (DefaultResult<[ProductData]>) -> Void

enum Method {
    case get
}

enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        default:
            self = .get
        }
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:          return "GET"
        }
    }
}

protocol Requestable { }

extension Requestable {
    /// Request api call
    /// - Parameters:
    ///   - method: method get or put
    ///   - url: url of the api
    ///   - params: params for the api
    ///   - callback: completion call back
    func request(method: Method, url: String, params: [String: Any]? = nil, callback: @escaping Handler) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        request.httpMethod = method.description
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    callback(.failure(500))
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        callback(.success(data!))
                    } else {
                        callback(.failure(httpResponse.statusCode))
                    }
                } else {
                    callback(.failure(500))
                }
            }
        })
        task.resume()
    }
}
