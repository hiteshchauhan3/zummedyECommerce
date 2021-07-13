//
//  CircularView.swift
//  DynamicPopup
//
//  Created by Hitesh on 12/07/21.
//

import UIKit

class CircularView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.height / 2
    }

}
