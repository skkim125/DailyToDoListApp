//
//  Enum.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import RealmSwift

enum TodoContents: String, CaseIterable {
    case memos = "메모"
    case deadline = "마감일"
    case tag = "태그"
    case isImortant = "우선순위"
    case addImage = "이미지 추가"
    
    var buttonTag: Int {
        switch self {
        case .deadline:
            return 0
        case .tag:
            return 1
        case .isImortant:
            return 2
        case .addImage:
            return 3
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
    
    var image: UIImage {
        switch self {
        case .today:
            return UIImage(systemName: "bag.circle.fill")!
        case .willDo:
            return UIImage(systemName: "calendar.circle.fill")!
        case .all:
            return UIImage(systemName: "tray.circle.fill")!
        case .isFlaged:
            return UIImage(systemName: "flag.circle.fill")!
        case .isDone:
            return UIImage(systemName: "checkmark.circle.fill")!
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
    
    var list: Results<Todo> {
        let realm = try! Realm()
        return try! realm.write {
            var list = realm.objects(Todo.self)
            switch self {
            case .all:
                return list
            case .today:
                return list.where { $0.deadline == Date()}
            case .willDo:
                return list.where { $0.deadline > Date()}
            case .isFlaged:
                return list.where { $0.isFlaged }
            case .isDone:
                return list.where { $0.isEnd }
            }
        }
    }
}
