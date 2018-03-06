//
//  MyLocationRealm.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 25..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

let categoryDictionary: [String: String] = ["MT1": "대형마트", "CS2": "편의점", "PS3": "어린이집,유치원", "SC4": "학교", "AC5": "학원", "PK6": "주차장", "OL7": "주유소,충전소", "SW8": "지하철역", "BK9": "은행", "CT1": "문화시설", "AG2": "중개업소", "PO3": "공공기관", "AT4": "관광명소", "AD5": "숙박", "FD6": "음식점", "CE7": "카페", "HP8": "병원", "PM9": "약국"]

class MyLocationRealm: Object {
    @objc dynamic var longitude: Double = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var category: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var distance: String = ""
    @objc dynamic var update: Date = Date() 
}
func addMyLocation(_ longitude: Double, _ latitude: Double, _ category: Int, _ name: String, _ address: String, _ distance: String, _ update: Date){
    let realm = try! Realm()
    let object = MyLocationRealm()
    object.longitude = longitude
    object.latitude = latitude
    object.category = category
    object.name = name
    object.address = address
    object.distance = distance
    object.update = update
    try! realm.write {
        realm.add(object)
    }
}

// 다음 api에서 parameter를 키로 넘길때도 있고 밸류로 넘길때가 있어서 두가지 경의 다 처리
func getCategory(_ string: String) -> Int{
    switch(string){
    case "MT1" :
        return 0
    case "대형마트":
        return 0
    case "CS2":
        return 1
    case "편의점":
        return 1
    case "PS3":
        return 2
    case "어린이집, 유치원":
        return 2
    case "SC4":
        return 3
    case "학교":
        return 3
    case "AC5":
        return 4
    case "학원":
        return 4
    case "PK6":
        return 5
    case "주차장":
        return 5
    case "OL7":
        return 6
    case "주유소, 충전소":
        return 6
    case "SW8":
        return 7
    case "지하철역":
        return 7
    case "BK9":
        return 8
    case "은행":
        return 8
    case "CT1":
        return 9
    case "문화시설":
        return 9
    case "AG2":
        return 10
    case "중개업소":
        return 10
    case "PO3":
        return 11
    case "공공기관":
        return 11
    case "AT4":
        return 12
    case "관광명소":
        return 12
    case "AD5":
        return 13
    case "숙박":
        return 13
    case "FD6":
        return 14
    case "음식점":
        return 14
    case "CE7":
        return 15
    case "카페":
        return 15
    case "HP8":
        return 16
    case "병원":
        return 16
    case "PM9":
        return 17
    case "약국":
        return 17
    default:
        return -1
    }
}


