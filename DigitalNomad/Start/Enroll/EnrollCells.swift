//
//  DateCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class LocationCell: UITableViewCell {
    
    @IBOutlet var locationLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class DateCell: UITableViewCell {

    @IBOutlet var pickerView: AKPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
