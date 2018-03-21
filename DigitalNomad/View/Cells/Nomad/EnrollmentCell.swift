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
        textField.addBorderBottom(height: 1)
        textField.addTarget(self, action: #selector(clickReturn), for: .editingDidEndOnExit)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickReturn(_ sender: UITextField){
        sender.endEditing(true)
    }
    
}
