//
//  ProductCell.swift
//  DynamicPopup
//
//  Created by Hridayedeep Gupta on 10/07/21.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var incrementStackView: UIStackView!
    @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var decrementBtn: UIButton!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var idlbl: UILabel!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var imgLoader: UIActivityIndicatorView!
    @IBOutlet weak var leftSeparator: UIView!
    @IBOutlet weak var rightSeparator: UIView!
    
    var productID:Int = 0
    var count = 0
    var downloadImage:((UIImage?,Int)->Void)?
    var incrementQuant:((Int,Int)->())?
    var decrementQuant:((Int,Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let maskPath = UIBezierPath(roundedRect: incrementStackView.bounds,
                                    byRoundingCorners: [.topLeft],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        incrementStackView.layer.mask = shape
        
    }
    @IBAction func incrementAction(_ sender: Any) {
        updateQuantity(count: +1)
    }
    @IBAction func decrementAction(_ sender: Any) {
        updateQuantity(count: -1)
    }
    
    func updateQuantity(count:Int16){
        if CoreDataManager.sharedManager.fetchAllProducts()?.contains(where: {$0.id == Int16(self.idlbl.text ?? "0")}) ?? false{
            let items = CoreDataManager.sharedManager.updateItemsCount(id: Int(self.idlbl.text ?? "0") ?? 0, count: count)
            self.itemsCount.text = "\(items)"
            hideDecrementLabel(count: Int16(items))
        }
    }
    
    func hideDecrementLabel(count:Int16){
        if count == 0{
            self.decrementBtn.isHidden = true
        }else{
            self.decrementBtn.isHidden = false
        }
    }
    
    /// Configure for cell
    /// - Parameters:
    ///   - product: product array
    ///   - url: url
    func configure(for product: ProductModel?,url:String? = "") {
        itemsCount.text = "\(product?.itemsCount ?? 0)"
        productID = Int(product?.id ?? 0)
        hideDecrementLabel(count: product?.itemsCount ?? 0)
        nameLabel.text = product?.title
        self.idlbl.text = "\(product?.id ?? 0)"
        priceLabel.text = "$" + String(product?.price ?? 0)
        if let productImg = product?.img {
            self.itemImage.image = UIImage(data: productImg)
        }else{
            let productViewModel = ProductViewModel()
            self.imgLoader.startAnimating()
            guard let url = URL(string: url ?? "") else {return}
            productViewModel.downloadImage(url: url, id: Int(product?.id ?? 0)) {[weak self] data, photoID in
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self?.imgLoader.stopAnimating()
                    self?.downloadImage?(UIImage(data: data), photoID)
                }
                CoreDataManager.sharedManager.saveImageData(data: data, id:Int(product?.id ?? 0))
            }
        }
    }
}

