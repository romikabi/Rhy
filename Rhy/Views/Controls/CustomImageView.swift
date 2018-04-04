//
//  CustomImageView.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 03.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 { didSet {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0 }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

}
