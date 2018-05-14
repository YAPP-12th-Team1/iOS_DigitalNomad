//
//  Date+.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 4. 11..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation

extension Date {
    static var yesterdayDate: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    static var tomorrowDate: Date {
        return Calendar.current.date(byAdding: .day, value: +1, to: Date())!
    }
    
    static var todayDateToString: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월 dd일"
        let today = dateFormatter.string(from: date)
        return today
    }
    
    static var todayStart: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    static var todayEnd: Date {
        let components = DateComponents(day: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: todayStart)!
    }
    
    static var yesterdayStart: Date {
        return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
    }
    
    static var yesterdayEnd: Date {
        let components = DateComponents(day: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: yesterdayStart)!
    }
    
    var dateInterval: Int {
        return Int(Date().timeIntervalSince(self)) / 86400 + 1
    }
    
    func convertToTime() -> String {    //formatForTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
