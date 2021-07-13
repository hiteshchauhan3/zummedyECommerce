//
//  APIRequest.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import Foundation
import UIKit
class APIRequest: NSObject, Requestable {
    
    ///
    /// Generate api request and calls api
    /// - Parameter callback: call back for api
    func fetchCategoryAndProduct(callback: @escaping ProductDataCallBack) {
        let url = EndPoint.getCategoryAndProduct.path
        DispatchQueue.global(qos: .background).async {
            self.callAPIToGetData(url: url) { (data) in
                switch data {
                case .success(let categoryAndProductData):
                    do {
                        let decoder = JSONDecoder()
                        let categoryAndProduct = try decoder.decode([ProductData].self, from: categoryAndProductData)
                        callback(.success(categoryAndProduct))
                    } catch {
                        callback(.failure(.decodeFailure))
                    }
                case .failure(_):
                    callback(.failure(.apiFailure))
                }
            }
        }
    }
    
    /// Get image data from url session
    /// - Parameters:
    ///   - url: url of image
    ///   - completion: completion handler for download
    /// - Returns: no retunrs
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    /// Download images
    /// - Parameters:
    ///   - url: url of the image
    ///   - id: id of the product
    ///   - completion: completion handler for the image downloaded
    /// - Returns: returns nothing
    func downloadImage(from url: URL,id:Int,completion:@escaping ((Data?,Int)->())) {
        print("Download Started")
            self.getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                completion(data,id)
            }
    }
}

extension APIRequest {
    /// Common method for api calling request
    /// - Parameters:
    ///   - url: url of the api
    ///   - callback: call back for api
    private func callAPIToGetData(url: String, callback: @escaping DefaultCallBack) {
        request(method: .get, url: url, params: nil) { (data) in
            switch data {
            case .success(let result):
                callback(.success(result))
            case .failure(_):
                callback(.failure((.apiFailure)))
            }
        }
    }
}
