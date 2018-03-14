//
//  DummyData.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class DummyData{
    let realm = try! Realm()
    init() {
        try! realm.write {
            realm.delete(realm.objects(UserInfo.self))
            realm.delete(realm.objects(EmailInfo.self))
            realm.delete(realm.objects(UserLocationInfo.self))
            realm.delete(realm.objects(ProjectInfo.self))
            realm.delete(realm.objects(GoalListInfo.self))
            realm.delete(realm.objects(WishListInfo.self))
        }
        //아래에 create 함수들을 넣으세요
        addUser(nil, "개발자")
    }
}
