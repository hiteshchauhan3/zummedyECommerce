//
//  ViewController.swift
//  DynamicPopup
//
//  Created by Hitesh on 09/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var categoryTabView: TabView!
    @IBOutlet weak var productsList: ItemsCollection!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    let productViewModel = ProductViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.productViewModel.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CoreDataManager.sharedManager.fetchAllProducts()?.count ?? 0 == 0 {
            productViewModel.fetchCategoryAndProduct()
        }
        productsList.pushVC = { [weak self] (id) in
            guard let self = self else {
                return
            }
            let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            vc.productID = id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension ViewController:ProductDetailsProtocol{
    func willLoadData() {
        self.loaderView.startAnimating()
    }
    
    func didFinishGettingData() {
        DispatchQueue.main.async {
            self.loaderView.stopAnimating()
            self.productsList.productModel = self.productViewModel.product
            self.productsList.products = CoreDataManager.sharedManager.fetchAllProducts()
            self.productsList.itemsCollectionView.reloadData()
        }        
    }
    
    func failedToGetData(_ error: Failure) {
        print(error)
    }
}
