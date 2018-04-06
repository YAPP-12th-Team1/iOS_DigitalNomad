//
//  Today.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 31..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation

func yesterdayDate() -> Date {
    let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    return date!
}
func tomorrowDate() -> Date {
    let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    return date!
}
func dateInterval(startDate: Date) -> Int {
    // 시작날짜~오늘날짜까지 몇일째 인지 구하는 함수
    let todayDate = Date()
    let interval = todayDate.timeIntervalSince(startDate)
    return (Int(interval) / 86400 + 1)
}
func  Dateformat() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)
    return today
}

