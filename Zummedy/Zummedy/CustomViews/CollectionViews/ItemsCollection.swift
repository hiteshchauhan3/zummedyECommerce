//
//  ItemsCollection.swift
//  DynamicPopup
//
//  Created by Hitesh on 10/07/21.
//

import UIKit

class ItemsCollection: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var products :[ProductModel]? = {
        return CoreDataManager.sharedManager.fetchAllProducts()
    }()
    var pushVC:((Int)->())?
    var productModel = [ProductData]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed("ItemsCollection", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        itemsCollectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
    }
}

extension ItemsCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushVC?(Int(products?[indexPath.row].id ?? 0))
    }
}
extension ItemsCollection: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            productModel.count > 0 ?
                cell.configure(for: self.products?[indexPath.row],url: self.productModel[indexPath.row].image) : cell.configure(for: self.products?[indexPath.row])
            cell.downloadImage = { [weak self] (image,Id) in
                if let productIndex = self?.products?.firstIndex(where: {$0.id == Id}){
                    collectionView.reloadItems(at: [IndexPath(item: productIndex, section: 0)])
                }
            }
            switch indexPath.row {
            case 0:
                cell.topSeparator.isHidden = true
                cell.leftSeparator.isHidden = true
                cell.bottomSeparator.isHidden = false
                cell.rightSeparator.isHidden = false
            case 1:
                cell.topSeparator.isHidden = true
                cell.bottomSeparator.isHidden = false
                cell.rightSeparator.isHidden = true
                cell.leftSeparator.isHidden = false
            case products?.count ?? 0 - 2:
                cell.bottomSeparator.isHidden = true
                cell.leftSeparator.isHidden = true
                cell.topSeparator.isHidden = false
                cell.rightSeparator.isHidden = false
            case products?.count ?? 0 - 1:
                cell.rightSeparator.isHidden = true
                cell.bottomSeparator.isHidden = true
                cell.topSeparator.isHidden = false
                cell.leftSeparator.isHidden = false
            case let x where x % 2 == 0:
                cell.leftSeparator.isHidden = true
                cell.rightSeparator.isHidden = false
                cell.bottomSeparator.isHidden = false
                cell.topSeparator.isHidden = false
            default:
                cell.rightSeparator.isHidden = true
                cell.leftSeparator.isHidden = false
                cell.bottomSeparator.isHidden = false
                cell.topSeparator.isHidden = false
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidthAndHeight = ((CGFloat(UIScreen.main.bounds.width)) / 2.0)
        return CGSize(width: itemWidthAndHeight , height: itemWidthAndHeight + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
