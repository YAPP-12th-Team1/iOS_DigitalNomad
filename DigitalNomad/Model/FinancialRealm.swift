//
//  FinancialRealm.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 25..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class FinancialRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var inOut: Bool = false
    @objc dynamic var category: Int = 0
    @objc dynamic var pid: Int = 0
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(FinancialRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addFinancial(_ inOut: Bool, _ category: Int, _ pid: Int){
    let realm = try! Realm()
    let object = FinancialRealm()
    object.id = object.incrementID()
    object.inOut = inOut
    object.category = category
    object.pid = pid
    try! realm.write {
        realm.add(object)
    }
}
