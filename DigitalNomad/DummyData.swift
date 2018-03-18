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
        addUser("서울특별시 노원구", "개발자")
        addProject("서울특별시 노원구", 5)
        
        //[일] 추가할 때 아래 세 줄처럼 (빈도수 체크를 위해 두번 넣은 데이터 있음)
        addGoalList("#일하자일해")
        try! realm.write{
            realm.objects(ProjectInfo.self).last!.goalLists.append(realm.objects(GoalListInfo.self).last!)
        }
        addGoalList("#일하자일해22")
        try! realm.write{
            realm.objects(ProjectInfo.self).last!.goalLists.append(realm.objects(GoalListInfo.self).last!)
        }
        addGoalList("#일하자일해22")
        try! realm.write{
            realm.objects(ProjectInfo.self).last!.goalLists.append(realm.objects(GoalListInfo.self).last!)
        }
        
        //[삶] 추가할 때 아래 세 줄처럼
        addWishList("쉬자")
        try! realm.write{
            realm.objects(ProjectInfo.self).last!.wishLists.append(realm.objects(WishListInfo.self).last!)
        }
    }
}
