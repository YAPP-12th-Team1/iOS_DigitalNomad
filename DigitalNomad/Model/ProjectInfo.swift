//
//  ProjectInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift


class ProjectInfo: Object{
    @objc dynamic var id: Int = 0               //Primary Key
    @objc dynamic var period: String = ""     //Not Null
    @objc dynamic var day: Int = 5              //default: 5
    
    var wishLists = List<WishListInfo>()
    var goalLists = List<GoalListInfo>()
    
    func incrementId() -> Int{
        let realm = try! Realm()
        return (realm.objects(ProjectInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addProject(_ day: Int = 5){
    let realm = try! Realm()
    let object = ProjectInfo()
    object.id = object.incrementId()
    object.period = todayDate()
    object.day = day
    try! realm.write{
        realm.add(object)
    }
}
