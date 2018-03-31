//
//  Today.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 31..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation

func todayDate() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)
    return today
}
