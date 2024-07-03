//
//  Extension.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import Foundation

extension DateFormatter {
    static func customDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        
        return dateFormatter.string(from: date)
    }
}

extension String {
    static func removeHash(_ hashtag: String) -> String {
        var text = hashtag
        text.removeFirst()
        
        return text
    }
}
