//
//  NewLevelCell.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 01.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit

class NewLevelCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let screenWidth = UIScreen.main.bounds.width
        containerWidthConstraint.constant = screenWidth - (8 * 2)
    }
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var label: UILabel!
}
