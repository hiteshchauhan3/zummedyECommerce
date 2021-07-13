//
//  CommonProtocols.swift
//  DynamicPopup
//
//  Created by Hitesh on 11/07/21.
//

import Foundation

/// Common protocols for view model
protocol ProductDetailsProtocol: AnyObject {
    func willLoadData()
    func didFinishGettingData()
    func failedToGetData(_ error: Failure)
}


