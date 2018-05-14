//
//  PopupMeetUpView2.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import MessageUI
import Toaster

protocol PopupMeetupViewDelegate {
    func touchUpSendButton()
    func touchUpCancelButton()
}

class PopupMeetUpView: UIView {

    @IBOutlet var receiverLabel: UILabel!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    var delegate: PopupMeetupViewDelegate?
    var realm: Realm!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupMeetUpView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func touchUpSendButton(_ sender: UIButton) {
        delegate?.touchUpSendButton()
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        delegate?.touchUpCancelButton()
    }
}
