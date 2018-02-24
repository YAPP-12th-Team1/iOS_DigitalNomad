//
//  ScheduleDaysCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 25..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ScheduleDaysCell: UICollectionViewCell {

    @IBOutlet var day: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        day.layer.borderColor = UIColor.lightGray.cgColor
        day.layer.borderWidth = 1
        day.layer.cornerRadius = day.frame.width / 2
        // Initialization code
    }

}
