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
import Firebase

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
        setUserData()
    }
    
    @IBAction func requestMeetup(_ sender: UIButton) {
        //마이페이지 디테일에서 코워킹 설정이 off되어 있으면 토스터를 띄움, 그렇지 않으면 팝업을 띄움
        
        if(userInfo.cowork){
            
            let popup = PopupMeetupView.instanceFromXib() as! PopupMeetupView
            popup.name = userInfo.nickname
            
            
            popup.setNeedsLayout()
            popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            popup.frame = (self.parentViewController()?.view.frame)!
            popup.view.alpha = 0
            self.parentViewController()?.view.addSubview(popup)
            UIView.animate(withDuration: 0.3) {
                popup.view.alpha = 1
            }
        } else {
            Toast(text: "코워킹 공개를 허용해 주세요. (설정 -> Co-working)", duration: Delay.short).show()
        }
    }
    
    /** user의 uid 로 리스트를 만들어서 반환 **/
    /** 이슈 : 본인은 빼고, coworking on 되어있는 사람 **/
    var list: Array<String> = []
    func usersList(){
        print("usersList 실행")
        
        let realm: Realm!
        realm = try! Realm()
        var userInfo: UserInfo!
        userInfo = realm.objects(UserInfo.self).first!
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let key = snapshot.value as? NSDictionary
            
            for i in key! {
                let newKey = i.key as? String
                if((newKey != Auth.auth().currentUser?.uid)){
                    var newValue =  i.value as! NSMutableDictionary
                    if let isCowork = newValue["cowork"]{
                        self.list.append(newKey as! String)
                    }
                }
            }
            print("test: ", self.list)
        })
    }

    var cardIndex = 0; // 첫번째 사람
    func setUserData() {
        realm = try! Realm()
        userInfo = realm.objects(UserInfo.self).first!

        //        var users = list
        //        print("setUserData(): ", users)
        //        위에서 데이터를 못받아오므로, 일단 데이터 박아두기
        
        let users = ["U2IENRkXiJWNkBAPqJaW3hLJk4e2", "9KSKbVtLegNxrtvXjn6WfJieL8J3"]
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users/\(users[cardIndex])").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let nickname = value?["nickname"] as? String ?? ""
            let job = value?["job"] as? String ?? ""
            let day = value?["day"] as? Int ?? 0
            let address = value?["address"] as? String ?? ""
            let introducing = value?["introducing"] as? String ?? ""
            
            print(value)
            print(job, ", ", day, ", ", nickname)
            
            self.name.text = nickname
            self.occupation.text = job
            self.days.text = String(day)+"일째"
            self.distance.text = address
            self.message.text = introducing
            self.cardIndex = self.cardIndex+1;
        })
    }
}

