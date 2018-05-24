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
    @objc dynamic var job: String?
    @objc dynamic var introducing: String?
    @objc dynamic var purpose: String?
}

func addUser(address: String, day: Int, purpose: String){
    let realm = try! Realm()
    let object = UserInfo()
    object.address = address
    object.purpose = purpose
    object.cowork = false
    try! realm.write{
        realm.add(object)
    }
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("users").child(uid).setValue([
        "email": Auth.auth().currentUser?.email ?? "NoEmail",
        "nickname": Auth.auth().currentUser?.displayName ?? "익명의유목민",
        "address": address,
        "cowork": false,
        "job": "",
        "day": 1,
        "purpose": purpose,
        "introducing": ""
    ])
 Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("emailInfo").setValue([
        "title": "",
        "context": ""
    ])
}

func addUser(address: String, day: Int, purpose: String, job: String, introducing: String, meetupPurpose: String, emailTitle: String, emailContent: String) {
    let realm = try! Realm()
    let object = UserInfo()
    object.address = address
    object.purpose = purpose
    object.cowork = true
    object.job = job
    object.introducing = introducing
    try! realm.write {
        realm.add(object)
    }
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("users").child(uid).setValue([
        "email": Auth.auth().currentUser?.email ?? "NoEmail",
        "nickname": Auth.auth().currentUser?.displayName ?? "익명의유목민",
        "address": address,
        "cowork": true,
        "job": job,
        "day": 1,
        "purpose": purpose,
        "introducing": introducing
        ])
    Database.database().reference().child("users").child(uid).child("emailInfo").setValue([
        "title": emailTitle,
        "context": emailContent
        ])
}



