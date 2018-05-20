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
    @objc dynamic var email: String = Auth.auth().currentUser?.email ?? "NoEmail"
    @objc dynamic var nickname: String = Auth.auth().currentUser?.displayName ?? "익명의유목민"   //Not Null
    @objc dynamic var image: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "ProfileNone"))!
    @objc dynamic var address: String?
    @objc dynamic var cowork: Bool = false                                                  //default: false
    @objc dynamic var job: String = ""
    @objc dynamic var introducing: String?
    @objc dynamic var purpose: String?
}

func addUser(_ address: String, _ day: Int, _ purpose: String){
    let realm = try! Realm()
    let object = UserInfo()
    object.address = address
    object.purpose = purpose

    // firebase
    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).setValue([
        "email": Auth.auth().currentUser?.email,
        "nickname": Auth.auth().currentUser?.displayName,
        "address": address,
        "cowork": false,
        "job": object.job,
        "day" : 1,
        "purpose" : purpose,
        "introducing": ""
    ])
    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("emailInfo").setValue([
        "title": "",
        "context": ""
    ])
    try! realm.write{
        realm.add(object)
    }
}

