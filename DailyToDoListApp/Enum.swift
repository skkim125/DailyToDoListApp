//
//  Enum.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import RealmSwift

enum TodoContents: String, CaseIterable {
    case memos
    case deadline = "마감일"
    case hashTag = "태그"
    case isImortant = "우선순위"
    case addImage = "이미지 추가"
    
    var buttonTag: Int {
        switch self {
        case .deadline:
            return 1
        case .hashTag:
            return 2
        case .isImortant:
            return 3
        case .addImage:
            return 4
        default:
            return -1
        }
    }
}

enum TodoContentsMemos: String, CaseIterable {
    case title = "제목"
    case memos = "메모"
}

enum SortType: String, CaseIterable {
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
