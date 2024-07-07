//
//  String+Extension.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import Foundation

extension String {
    static func removeHash(_ hashtag: String) -> String {
        var text = hashtag
        text.removeFirst()
        
        return text
    }
}
