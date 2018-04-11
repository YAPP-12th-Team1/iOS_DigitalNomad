//
//  EnrollmentCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 21..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class EnrollmentCell: UITableViewCell {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(clickReturn), for: .editingDidEndOnExit)
        textField.autocorrectionType = .no
    }
    
    @objc func clickReturn(_ sender: UITextField){
        sender.endEditing(true)
    }
}
