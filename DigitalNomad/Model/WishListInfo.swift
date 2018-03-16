//
//  WishListInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class WishListInfo: Object{
    @objc dynamic var id: Int = 0           //Primary Key
    @objc dynamic var pid: Int = 0          //Foreign Key
    @objc dynamic var todo: String = ""     //Not Null
    @objc dynamic var status: Bool = false  //default: false
    
    let projects = LinkingObjects(fromType: ProjectInfo.self, property: "wishLists")
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WishListInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addWishList(_ todo: String){
    let realm = try! Realm()
    let object = WishListInfo()
    object.todo = todo
    try! realm.write{
        realm.add(object)
    }
}
