//
//  CornerViews.swift
//  PinBoard
//
//  Created by Salute on 29/07/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

@IBDesignable
class CornerViews: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
