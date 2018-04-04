//
//  CustomTextField.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 03.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class CustomTextField: UITextField {
    @IBInspectable var placeholderTextColor : UIColor = .black {
        didSet{
            drawTextView()
        }
    }
    private func drawTextView(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : placeholderTextColor])
    }
}
