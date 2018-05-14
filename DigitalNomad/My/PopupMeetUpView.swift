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

protocol PopupMeetUpViewDelegate {
    func touchUpSendButton()
    func touchUpCancelButton()
}

class PopupMeetUpView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var receiverLabel: UILabel!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    var delegate: PopupMeetUpViewDelegate?
    var realm: Realm!
    
    var receiver: String?
    var sender: String?
    var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.receiverLabel.text = receiver
        self.senderLabel.text = sender
        self.titleLabel.text = title
    }

    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupMeetUpView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    //MyViewController에 구현체 있음
    @IBAction func touchUpSendButton(_ sender: UIButton) {
        delegate?.touchUpSendButton()
    }
    
    //MyViewController에 구현체 있음
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        delegate?.touchUpCancelButton()
    }
}
