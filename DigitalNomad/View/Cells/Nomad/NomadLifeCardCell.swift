//
//  NomadLifeCardCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 22..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadLifeCardCell: UICollectionViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var card: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = view.frame.height / 2
        card.layer.cornerRadius = card.frame.height / 2
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.black.cgColor
        card.layer.masksToBounds = true
    }
}
