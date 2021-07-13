//
//  TabView.swift
//  DynamicPopup
//
//  Created by Hitesh on 10/07/21.
//

import UIKit
enum Tabs: String, CaseIterable {
    case newArrivals, clothes, shoes, handbags, trends
    var localizedKey: String {
        switch self {
        case .newArrivals:
            return "New Arrivals"

        case .clothes:
            return "Clothes"

        case .shoes:
            return "Shoes"

        case .handbags:
            return "Handbags"

        case .trends:
            return "Trends"
        }
    }
    var index: Int {
        return Tabs.allCases.firstIndex(of: self) ?? 0
    }
}
class TabView: UIView {
    /// TabViewConfiguration configuration for the collection view spacing
    private struct TabViewConfiguration {
        static let minimumInterItemSpacing: CGFloat = 15
        static let minimumLineSpacing: CGFloat = 0
    }

    /// Array having data to show
    var dataArray: [Tabs] = []
    /// Selected Item
    var selectedItem: Int = -1 {
        didSet {
            tabsCollection.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    /// To check if the cells occupy the whole screen or not
    private var fitToScreen: Bool = false
    /// Size difference in case of cell not occupying the screen
    private var sizeDiff: CGFloat = 0.0
    /// Stores the value at the time of configuring. Gets use if reload is called second time
    private var selectedIndex: Int = -1
    /// Sends the Selected Item to parent view swift
    var didSelectItemAt:((_ index: Int) -> ())?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tabsCollection: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed("TabView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let nib = UINib(nibName: "TabCollectionCell", bundle: nil)
        tabsCollection.register(nib, forCellWithReuseIdentifier: "TabCollectionCell")
        dataArray = Tabs.allCases
//        selectedItem = 0
        tabsCollection.delegate = self
        tabsCollection.dataSource = self
    }
    func configureCollectionView(atIndex index: Int) {
        DispatchQueue.main.async {
            self.tabsCollection.selectItem(at: IndexPath.init(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
            self.tabsCollection.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: (index != 4))
            self.selectedIndex = index
        }
    }
}

extension TabView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionCell", for: indexPath) as? TabCollectionCell {
            cell.titleLabel.text = dataArray[indexPath.item].localizedKey
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: 500, height: self.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let str = dataArray[indexPath.item].localizedKey

        let estimatedRect = NSString.init(string: str).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)], context: nil)
        /// Check for the bool value and add the remaining size to cells in case opf true
        /// Adding value to fill in the screen because width is getting calculated using string.
        if fitToScreen {
            return CGSize.init(width: estimatedRect.size.width + (sizeDiff / CGFloat(dataArray.count)) + 1, height: self.frame.height)
        } else {
            return CGSize.init(width: estimatedRect.size.width, height: self.frame.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// Check for the last cell frame with the screen width
        if indexPath.item == dataArray.count - 1 {
            if cell.frame.maxX <= UIScreen.main.bounds.width {
                fitToScreen = true
                sizeDiff = UIScreen.main.bounds.width - cell.frame.maxX
                DispatchQueue.main.async {
                    collectionView.reloadData()
                    /// Configuring collectionview selection view after reload
                    self.configureCollectionView(atIndex: self.selectedIndex)
                }
            } else {
                fitToScreen = false
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let didSelectItemAt = didSelectItemAt {
            didSelectItemAt(indexPath.item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return TabViewConfiguration.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        /// Spacing of 35 between cells
        return TabViewConfiguration.minimumInterItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        /// 20 spaces from left and right
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
}
