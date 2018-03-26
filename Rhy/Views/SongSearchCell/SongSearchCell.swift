//
//  SongSearchCell.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 09.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit

class SongSearchCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let screenWidth = UIScreen.main.bounds.width
        containerWidthConstraint.constant = screenWidth - (8 * 2)
    }
    var item: SongItem?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
}
