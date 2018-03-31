//
//  UserLocationInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class UserLocationInfo: Object{

    @objc dynamic var longitude: Double = 0     //Not Null
    @objc dynamic var latitude: Double = 0      //Not Null
}

func addUserLocation(_ longitude: Double, _ latitude: Double){
    let realm = try! Realm()
    let object = UserLocationInfo()
    object.longitude = longitude
    object.latitude = latitude
    try! realm.write{
        realm.add(object)
    }
}
