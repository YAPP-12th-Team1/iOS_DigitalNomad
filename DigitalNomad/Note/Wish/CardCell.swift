//
//  CardCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 16..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frame.height / 2
    }
}
