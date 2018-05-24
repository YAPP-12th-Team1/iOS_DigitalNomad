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
    @IBOutlet var locationTextField: UITextField!
}

//MARK:- 2번 섹션 커스텀 셀
class DateCell: UITableViewCell {
    @IBOutlet var pickerView: AKPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pickerView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.pickerView.textColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.viewDepth = UIScreen.main.bounds.height
    }
}

//MARK:- 3번 섹션 커스텀 셀
class PurposeCell: UITableViewCell {
    @IBOutlet var purposeTextField: UITextField!
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

//MARK:- 5번 섹션 커스텀 셀
class CoworkingCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextField: UITextField!
}

//MARK:- 6번 섹션 커스텀 셀
class EmailCell: UITableViewCell {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
}
