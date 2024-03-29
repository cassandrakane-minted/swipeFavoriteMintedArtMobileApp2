//
//  OverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 4/24/15.
//  Copyright (c) 2015 Eugene Andreyev. All rights reserved.
//

import UIKit

public class OverlayView: UIView {
    
    public var overlayState: SwipeResultDirection?
    public var designInfo: [String : String] = [
        "artistName": "",
        "designName": "",
        "artistLocation": "",
        "designImgUrl": "",
        "artistProfileImgUrl": "",
        "design_id_str": ""
    ]
    
    @available(*, unavailable, message="Use updateWithProgress(percentage:) instead")
    public var overlayStrength: CGFloat = 0.0
    
    @available(*, introduced=3.1.2)
    public func updateWithProgress(percentage: CGFloat) {
        alpha = percentage
    }

}
