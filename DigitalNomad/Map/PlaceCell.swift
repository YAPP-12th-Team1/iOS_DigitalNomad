//
//  PlaceCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
