//
//  Today.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 31..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation

func formatForTime(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func yesterdayDate() -> Date {
    let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    return date!
}
func tomorrowDate() -> Date {
    let date = Calendar.current.date(byAdding: .day, value: +1, to: Date())
    return date!
}

func dateInterval(startDate: Date) -> Int {
    // 시작날짜~오늘날짜까지 몇일째 인지 구하는 함수
    let todayDate = Date()
    let interval = todayDate.timeIntervalSince(startDate)
    return (Int(interval) / 86400 + 1)
}
func todayDateToString() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)
    return today
}

let todayStart = Calendar.current.startOfDay(for: Date())
let todayEnd: Date = {
    let components = DateComponents(day: 1, second: -1)
    return Calendar.current.date(byAdding: components, to: todayStart)!
}()

let yesterdayStart = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
let yesterdayEnd: Date = {
    let components = DateComponents(day: 1, second: -1)
    return Calendar.current.date(byAdding: components, to: yesterdayStart)!
}()

