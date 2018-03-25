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
        "cowrk": false,
        "job": object.job
    ])
    
    try! realm.write{
        realm.add(object)
    }
}

// 본인을 제외한 유저 id List
func usersList() {
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.child("users").observeSingleEvent(of: .value, with: { (user) in
        // Get user value
        let value = user.value as? NSDictionary
        let username = value?["username"] as? String ?? ""
        print("value", value)
        print("username", username)
        
    }) { (error) in
        print(error.localizedDescription)
    }
}
