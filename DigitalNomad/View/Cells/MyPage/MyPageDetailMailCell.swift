//
//  MyPageDetailMailCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyPageDetailMailCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var title: UITextField!
    @IBOutlet var message: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.autocorrectionType = .no
        message.autocorrectionType = .no
        title.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        message.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(red: 87/255, green: 83/255, blue: 83/255, alpha: 1).cgColor
        view.layer.borderWidth = 1
        title.addBorderBottom(height: 1.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickReturnButton(){
        if(title.isFirstResponder){
            title.resignFirstResponder()
        } else if(message.isFirstResponder){
            message.resignFirstResponder()
        }
    }
    
}
