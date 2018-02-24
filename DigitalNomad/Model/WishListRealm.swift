//
//  WishListRealm.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 25..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class WishListRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var status: Int = 0
    @objc dynamic var pid: Int = 0
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WishListRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addWishList(_ name: String, _ status: Int, _ pid: Int){
    let realm = try! Realm()
    let object = WishListRealm()
    object.id = object.incrementID()
    object.name = name
    object.status = status
    object.pid = pid
    try! realm.write {
        realm.add(object)
    }
}
