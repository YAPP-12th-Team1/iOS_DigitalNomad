//
//  EmailInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift

class EmailInfo: Object{
    @objc dynamic var title: String = ""    //Not Null
    @objc dynamic var context: String = ""  //Not Null
}

func addEmail(_ title: String, _ context: String){
    let realm = try! Realm()
    let object = EmailInfo()
    object.title = title
    object.context = context
    try! realm.write{
        realm.add(object)
    }
}

//마이페이지 디테일의 밋업 메세지에 들어갈 내용
