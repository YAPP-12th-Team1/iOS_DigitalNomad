//
//  MyPageDetailMailCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageDetailMailCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var title: UITextField!
    @IBOutlet var message: UITextField!
    var realm: Realm!
    var emailInfo: EmailInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        let userId = realm.objects(UserInfo.self).last!.id
        emailInfo = realm.objects(EmailInfo.self).filter("userId = \(userId)").first
        title.autocorrectionType = .no
        message.autocorrectionType = .no
        title.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        message.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        view.layer.cornerRadius = 5
        view.layer.borderColor = #colorLiteral(red: 0.3411764706, green: 0.3254901961, blue: 0.3254901961, alpha: 1)
        view.layer.borderWidth = 1
        title.addBorderBottom(height: 1.0)
        
        if let email = emailInfo {
            title.text = email.title
            message.text = email.context
        } else {
            title.text = nil
            message.text = nil
        }
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
