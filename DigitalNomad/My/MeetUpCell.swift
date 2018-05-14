//
//  MeetUpCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import FSPagerView

protocol MeetUpCellDelegate {
    func touchUpMeetupButton()
}

class MeetUpCell: FSPagerViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var jobLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    var delegate: MeetUpCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MyViewController에 구현체 있음
    @IBAction func touchUpMeetupButton(_ sender: UIButton) {
        delegate?.touchUpMeetupButton()
    }
}
