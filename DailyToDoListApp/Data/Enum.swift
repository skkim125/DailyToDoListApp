//
//  Enum.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import RealmSwift

enum SortType: String {
    case defualt = "최근추가순"
    case importantValue = "우선순위순"
    case deadline = "마감일자순"
    
    var updateValueType: String {
        switch self {
        case .defualt:
            return "date"
        case .importantValue:
            return "importantValue"
        case .deadline:
            return "deadline"
        }
    }
}

enum ImportantValue: String, CaseIterable {
    case low = "낮음"
    case mid = "보통"
    case high = "높음"
    
    var value: Int {
        switch self {
        case .low:
            return 0
        case .mid:
            return 1
        case .high:
            return 2
        }
    }
}

enum TodoContents: String, CaseIterable {
    case deadline = "마감일"
    case hashTag = "태그"
    case importantValue = "우선순위"
    case addImage = "이미지 추가"
    
    var buttonTag: Int {
        switch self {
        case .deadline:
            return 1
        case .hashTag:
            return 2
        case .importantValue:
            return 3
        case .addImage:
            return 4
        default:
            return -1
        }
    }
}

enum ListSortType: String, CaseIterable {
    case today = "오늘"
    case willDo = "예정"
    case all = "전체"
    case isFlaged = "깃발 표시"
    case isDone = "완료됨"
    
    var image: String {
        switch self {
        case .today:
            return "bag.circle.fill"
        case .willDo:
            return "calendar.circle.fill"
        case .all:
            return "tray.circle.fill"
        case .isFlaged:
            return "flag.circle.fill"
        case .isDone:
            return "checkmark.circle.fill"
        }
    }
    
    var imageTintColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .willDo:
            return .systemPink
        case .all:
            return .systemGray
        case .isFlaged:
            return .systemOrange
        case .isDone:
            return .lightGray
        }
    }
    
}

enum FolderColor: String {
    case red = "FC2B2D"
    case blue = "3B81F5"
    case green = "30D33B"
    case orange = "FD8D0E"
}
