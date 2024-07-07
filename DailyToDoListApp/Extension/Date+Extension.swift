//
//  Date+Extension.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import Foundation

extension Date {
    static func krDate(date: Date) -> Date {
        let krTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let secondsFromGMT = krTimeZone.secondsFromGMT(for: date)
        let krDate = date.addingTimeInterval(TimeInterval(secondsFromGMT))
        
        return krDate
    }
}
