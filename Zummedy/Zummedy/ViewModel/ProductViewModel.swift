//
//  ProductViewModel.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import Foundation
import UIKit
class ProductViewModel {
   
    weak var delegate: ProductDetailsProtocol?
    var product = [ProductData]()
    
    /// Function to assign product data
    /// - Parameter data: product instance
    func assignProductData(data: [ProductData]) {
        self.product = data
    }
    
    /// Fetch products call api
    func fetchCategoryAndProduct() {
        let apiRequest = APIRequest()
        self.delegate?.willLoadData()
        apiRequest.fetchCategoryAndProduct { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let categoryAndProductData):
                self.assignProductData(data: categoryAndProductData)
                categoryAndProductData.forEach{CoreDataManager.sharedManager.addData(productData: $0)}
                self.delegate?.didFinishGettingData()
            case .failure(let error):
                self.delegate?.failedToGetData(error)
                print("error = \(error)")
            }
        }
    }
    /// Downloads image
    /// - Parameters:
    ///   - url: url of the image
    ///   - id: id of the product
    ///   - completion: completion handler for download
    func downloadImage(url:URL,id:Int,completion:@escaping ((Data?,Int)->Void)){
        let apiRequest = APIRequest()
        apiRequest.downloadImage(from: url,id:id ) { data,id in
            completion(data,id)
        }
    }
}

extension ProductViewModel {
    
    /// Get number of products
    /// - Returns: number of products
    func getNumberOfProduct() -> Int {
        return product.count
    }
    
    /// Get product for specific inndex
    /// - Parameter index: index
    /// - Returns: product data
    func getProductForIndex(index: Int) -> ProductData {
        return product[index]
    }
}
