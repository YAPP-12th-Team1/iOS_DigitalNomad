//
//  MyHashtagCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyHashtagCell: UICollectionViewCell {
    
    @IBOutlet var hashtagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.hashtagLabel.layer.borderWidth = 2
        self.hashtagLabel.layer.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.hashtagLabel.layer.cornerRadius = 10
        self.hashtagLabel.clipsToBounds = true
    }
}
