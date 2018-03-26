//
//  LevelSelectCell.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 24.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit

class LevelSelectCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let screenWidth = UIScreen.main.bounds.width
        containerWidthConstraint.constant = screenWidth - (8 * 2)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var heartWidth: NSLayoutConstraint!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    func fill(with level: Level){
        titleLabel.text = level.title
        authorLabel.text = level.author
        setRating(rating: 0.6)
        setStarred(true)
        let nps = (Double(level.nodes.count) / Double((level.length/1000)))
        infoLabel.text = "\(String(format: "%.2f", nps)) nodes per second"
    }
    
    func setRating(rating: CGFloat){
        ratingConstraint.constant = rating * -heartWidth.constant
    }
    
    func setStarred(_ starred: Bool){
        if starred{
            starButton.imageView?.image = #imageLiteral(resourceName: "star-filled")
        }
        else{
            starButton.imageView?.image = #imageLiteral(resourceName: "star")
        }
    }
}
