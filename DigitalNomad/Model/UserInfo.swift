//
//  UserInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import GoogleSignIn

class UserInfo: Object{
    @objc dynamic var id: Int = 0                                                           //Primary Key
    @objc dynamic var email: String = Auth.auth().currentUser?.email ?? "NoEmail"
    @objc dynamic var nickname: String = Auth.auth().currentUser?.displayName ?? "Noname"   //Not Null
    @objc dynamic var image: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "profile.png"))!
    @objc dynamic var address: String?
    @objc dynamic var cowork: Bool = false                                                  //default: false
    @objc dynamic var job: String = ""
    @objc dynamic var introducing: String?
    @objc dynamic var purpose: String?

    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(UserInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addUser(_ address: String?, _ job: String){
    let realm = try! Realm()
    let object = UserInfo()
    let id = object.incrementID()
    object.id = id
    object.address = address
    object.job = job

    // firebase
    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).setValue([
        "id": id,
        "email": Auth.auth().currentUser?.email,
        "nickname": Auth.auth().currentUser?.displayName,
        "address": object.address,
        "cowork": false,
        "job": object.job
    ])
    
    try! realm.write{
        realm.add(object)
    }
}

/** user의 uid 로 리스트를 만들어서 반환 **/
/** 이슈 : 본인은 빼고, coworking on 되어있는 사람 **/
func usersList() -> [String] {
    print("usersList 실행")
    
    let realm: Realm!
    realm = try! Realm()
    var userInfo: UserInfo!
    userInfo = realm.objects(UserInfo.self).first!
    
    var ref: DatabaseReference!
    ref = Database.database().reference()
    var list: Array<String> = []
    
    ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
        let key = snapshot.value as? NSDictionary
        
        for i in key! {
            let newKey = i.key as? String
            if((newKey != Auth.auth().currentUser?.uid)){
                
                var newValue =  i.value as! NSMutableDictionary
//                print("newValue: ", newValue["cowork"])
                if let isCowork = newValue["cowork"]{
                    list.append(newKey as! String)
//                    print("저장@")
                }
            }
        }
//        print(list)
    })
    return list
}

