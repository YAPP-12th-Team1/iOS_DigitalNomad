//
//  ProjectRealm.swift
//  
//
//  Created by Presto on 2018. 2. 25..
//

import Foundation
import RealmSwift

class ProjectRealm: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var location: String = ""
    @objc dynamic var period: Int = 0
    @objc dynamic var day: Int = 5
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(ProjectRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addProject(_ location: String, _ period: Int, _ day: Int){
    let realm = try! Realm()
    let object = ProjectRealm()
    object.id = object.incrementID()
    object.location = location
    object.period = period
    object.day = day
    try! realm.write {
        realm.add(object)
    }
}

