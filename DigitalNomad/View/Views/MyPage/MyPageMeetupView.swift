//
//  MyPageMeetupView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Toaster
import RealmSwift

class MyPageMeetupView: UIView {
    
    @IBOutlet var buttonMeetup: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var occupation: UILabel!
    @IBOutlet var days: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var distance: UILabel!
    var realm: Realm!
    var userInfo: UserInfo!
    var emailInfo: EmailInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ToastView.appearance().bottomOffsetPortrait = 49 + 20
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        buttonMeetup.layer.cornerRadius = 5
        
        setUserData()
    }
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageMeetupView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func showNextPerson(_ sender: UIButton) {
        
    }
    
    @IBAction func requestMeetup(_ sender: UIButton) {
        //마이페이지 디테일에서 코워킹 설정이 off되어 있으면 토스터를 띄움, 그렇지 않으면 팝업을 띄움
        if(userInfo.cowork){
            
            let popup = PopupMeetupView.instanceFromXib() as! PopupMeetupView
            popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            popup.frame = (self.parentViewController()?.view.frame)!
            popup.view.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                popup.view.alpha = 1
            }) { _ in
                self.parentViewController()?.view.addSubview(popup)
            }
        } else {
            Toast(text: "코워킹 공개를 허용해 주세요. (설정 -> Co-working)", duration: Delay.short).show()
        }
    }
    
    // 보여줘야할 사람 세팅
    func setUserData() {
        let users = usersList()
        
        realm = try! Realm()
        userInfo = realm.objects(UserInfo.self).first!
//        emailInfo = realm.objects(EmailInfo.self).first!
        
        name.text = userInfo.nickname
        occupation.text = userInfo.job
        days.text = "10" // 일단 디폴트로 10
//        message.text = emailInfo.context
        message.text = "dd"
        distance.text = "10" // 일단 디폴트로 10
    }
    
}

