//
//  DetailViewController.swift
//  DynamicPopup
//
//  Created by Hitesh on 12/07/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var imgCollectionView: DetailCollectionView!
    
    @IBOutlet weak var addBasketBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    var productID = 0
    var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBasketBtn.layer.cornerRadius = self.addBasketBtn.bounds.height / 2
        let productData = CoreDataManager.sharedManager.fetchAllProducts()?.first(where: {$0.id == productID})
        priceLbl.text = "$" + "\(productData?.price ?? 0)"
        productNameLabel.text = "\(productData?.title?.split(separator: " ").first ?? "")"
        imgCollectionView.imagesArr = Array(repeating: UIImage(data: productData?.img ?? Data()) ?? UIImage(), count: 3)
        imgCollectionView.reloadData()
        imgCollectionView.indexPathForSelected = {[weak self] (indexPath) in
            self?.row = indexPath?.row ?? 0
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func previousAction(_ sender: Any) {
        if row < 0{
            row = 0
        }
        if self.row == 0{
            return
        }
        let collectionBounds = self.imgCollectionView.bounds
               let contentOffset = CGFloat(floor(self.imgCollectionView.contentOffset.x - collectionBounds.size.width))
               self.moveCollectionToFrame(contentOffset: contentOffset)
        self.row = row - 1

    }
    @IBAction func forwardAction(_ sender: Any) {
        if row > self.imgCollectionView.imagesArr.count - 1{
            row = self.imgCollectionView.imagesArr.count - 1
        }
        if self.row == self.imgCollectionView.imagesArr.count - 1{
            return
        }
        let collectionBounds = self.imgCollectionView.bounds
               let contentOffset = CGFloat(floor(self.imgCollectionView.contentOffset.x + collectionBounds.size.width))
               self.moveCollectionToFrame(contentOffset: contentOffset)
        self.row = row + 1
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.imgCollectionView.contentOffset.y ,width : self.imgCollectionView.frame.width,height : self.imgCollectionView.frame.height)
        self.imgCollectionView.scrollRectToVisible(frame, animated: true)
    }
}

