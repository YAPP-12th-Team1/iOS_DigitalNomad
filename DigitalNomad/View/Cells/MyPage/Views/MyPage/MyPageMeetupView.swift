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
import FirebaseStorage
import SDWebImage

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
//        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true

        
        buttonMeetup.layer.cornerRadius = 5
        self.usersList()
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
            
            // popup 으로 데이터 보내는 부분
            popup.name = popUser
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
    var popUser:String = ""
    var list: Array<String> = []
    func usersList(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let key = snapshot.value as? NSDictionary
            
            for i in key! {
                let newKey = i.key as? String
                if((newKey != Auth.auth().currentUser?.uid)){
                    let newValue =  i.value as! NSMutableDictionary
                    if newValue["cowork"] != nil{
                        self.list.append(newKey as! String)
                    }
                }
            }
            self.setUserData()
        })
    }

    var cardIndex = 0; // 첫번째 사람
    func setUserData() {
        realm = try! Realm()
        userInfo = realm.objects(UserInfo.self).first!

        let users = list
//        print("setUserData(): ", users)
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(users[cardIndex])").observeSingleEvent(of: .value, with: { (snapshot) in

            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            let job = value?["job"] as? String ?? ""
            let day = value?["day"] as? Int ?? 0
            let address = value?["address"] as? String ?? ""
            let introducing = value?["introducing"] as? String ?? ""
            
            if let profileImage = value?["profileImage"] as? String {
                let imageRef = URL(string: profileImage)
                self.imageView.sd_setImage(with: imageRef, placeholderImage: UIImage())
            } else {
                self.imageView.image = UIImage(named: "Usersample.png")
            }
            
            self.name.text = nickname
            self.occupation.text = job
            self.days.text = "유목 생활 " + String(day) + "일째"
            self.distance.text = address
            self.message.text = introducing
            self.popUser = users[self.cardIndex]
            self.cardIndex = self.cardIndex+1;
            if(self.cardIndex == self.list.count){
                self.cardIndex = 0;
            }
        })
    }

    
}

