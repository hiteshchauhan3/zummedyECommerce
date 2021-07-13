//
//  BottomTabView.swift
//  DynamicPopup
//
//  Created by Hitesh on 12/07/21.
//

import UIKit

class BottomTabView: UIView {

    @IBOutlet var contentView: UIView!
    private var middleButton = UIButton()
    
    //MARK: Initializer(s)
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("BottomTabView", owner: self, options: nil)
        addSubview(contentView)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        middleButton.frame.size = CGSize(width: 100, height: 100)
        middleButton.layer.masksToBounds = true
        middleButton.contentMode = .scaleAspectFit
        middleButton.setImage(UIImage(named: "cart"), for: .normal)
        middleButton.backgroundColor = .white
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
        UIScreen.main.bounds.height - 40)
        
        addSubview(middleButton)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        middleButton.dropShadowOnCircularView()
        self.dropShadowOnCircularView()
    }
}
extension UIView{
    func dropShadowOnCircularView(cornerRadius:CGFloat = 35.0){
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = cornerRadius / 2.0
        let dx:CGFloat = 12
        layer.shadowPath = UIBezierPath(rect: self.bounds.insetBy(dx: dx, dy: dx)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
