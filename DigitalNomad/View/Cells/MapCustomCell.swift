//
//  MapCustomCell.swift
//  DigitalNomad
//
//  Created by 양종열 on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MapCustomCell: UITableViewCell {
    
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var placeName: UITextField!
    @IBOutlet var placeAddress: UITextField!
    @IBOutlet var distance: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
