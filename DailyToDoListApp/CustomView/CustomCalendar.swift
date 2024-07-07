//
//  CustomCalendar.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/6/24.
//

import UIKit
import FSCalendar

class CustomCalendar: FSCalendar {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        locale = Locale(identifier: "ko_KR")
        scope = .month
        
        appearance.headerDateFormat = "YYYY년 MM월"
        appearance.headerTitleAlignment = .center
        appearance.headerTitleColor = .white
        appearance.headerMinimumDissolvedAlpha = 0.0
        
        appearance.caseOptions = .weekdayUsesSingleUpperCase
        appearance.eventDefaultColor = .systemOrange
        appearance.eventSelectionColor = .systemOrange
        appearance.eventOffset = CGPoint(x: 0, y: -8)
        appearance.todayColor = .systemRed
        appearance.titleFont = .boldSystemFont(ofSize: 15)
        appearance.titleDefaultColor = .white
        appearance.titleWeekendColor = .red
        appearance.weekdayTextColor = .gray
        
        backgroundColor = .systemGray5
        tintColor = .systemBlue
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    static func krDate(date: Date) -> Date {
        let krTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let secondsFromGMT = krTimeZone.secondsFromGMT(for: date)
        let krDate = date.addingTimeInterval(TimeInterval(secondsFromGMT))
        
        return krDate
    }
}
