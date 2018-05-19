//
//  DateCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import AKPickerView_Swift

//MARK:- 1번 섹션 커스템 셀
class LocationCell: UITableViewCell {
    
    @IBOutlet var locationLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:- 2번 섹션 커스텀 셀
class DateCell: UITableViewCell {

    @IBOutlet var pickerView: AKPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:- 3번 섹션 커스텀 셀
class PurposeCell: UITableViewCell {
    
    @IBOutlet var purposeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:- 4번 섹션 커스텀 셀
protocol ConnectCellDeleagte {
    func touchUpYesButton()
    func touchUpNoButton()
}

class ConnectCell: UITableViewCell {
    
    var delegate: ConnectCellDeleagte?
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchUpYesButton(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        self.noButton.isSelected = !sender.isSelected
        delegate?.touchUpYesButton()
    }
    
    @IBAction func touchUpNoButton(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        self.yesButton.isSelected = !sender.isSelected
        delegate?.touchUpNoButton()
    }
}
