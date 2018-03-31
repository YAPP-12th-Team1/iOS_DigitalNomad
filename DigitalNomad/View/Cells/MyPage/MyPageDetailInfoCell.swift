//
//  MyPageDetailInfoCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyPageDetailInfoCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickReturnButton(){
        textField.resignFirstResponder()
    }
    
}
