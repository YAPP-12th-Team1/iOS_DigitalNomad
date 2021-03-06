//
//  GoalListInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class GoalListInfo: Object{
    @objc dynamic var id: Int = 0           //Primary Key
    @objc dynamic var pid: Int = 0          //Foreign Key
    @objc dynamic var date: Date = Date()
    @objc dynamic var todo: String = ""     //Not Null
    @objc dynamic var status: Bool = false  //default: false
    @objc dynamic var importance: Int = 0   //default: 0, 0/1/2
    
    let projects = LinkingObjects(fromType: ProjectInfo.self, property: "goalLists")
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(ProjectInfo.self).last!.goalLists.max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addGoalList(_ todo: String){
    let realm = try! Realm()
    let object = GoalListInfo()
    object.id = object.incrementID()
    object.todo = todo
    try! realm.write{
        realm.add(object)
    }
}


