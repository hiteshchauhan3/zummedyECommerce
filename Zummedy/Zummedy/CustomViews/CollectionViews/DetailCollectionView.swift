//
//  DetailCollectionView.swift
//  DynamicPopup
//
//  Created by Hitesh on 12/07/21.
//

import UIKit

class DetailCollectionView: UICollectionView {
    var imagesArr = [UIImage]()

    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    var indexPathForSelected : ((IndexPath?)->())?
}
extension DetailCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell{
            cell.imageView.image = imagesArr[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width - 20, height:collectionView.frame.size.height - 20)
   }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            indexPathForSelected?(indexPath)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            indexPathForSelected?(indexPath)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            indexPathForSelected?(indexPath)
        }
    }
}
