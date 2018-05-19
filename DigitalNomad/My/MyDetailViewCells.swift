//
//  Section1Cell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 18..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class Section1Cell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

protocol Section2CoworkingCellDelegate {
    func changeCoworkingSwitchValue()
}

class Section2CoworkingCell: UITableViewCell {
    
    @IBOutlet var coworkingSwitch: UISwitch!
    var delegate: Section2CoworkingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func changeCoworkingSwitchValue(_ sender: UISwitch) {
        delegate?.changeCoworkingSwitchValue()
    }
}

class Section2Cell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class Section3Cell: UITableViewCell {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

