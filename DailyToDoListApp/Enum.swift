//
//  Enum.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import Foundation

enum TodoContents: String, CaseIterable {
    case memos = "메모"
    case deadline = "마감일"
    case tag = "태그"
    case isImortant = "우선순위"
    case addImage = "이미지 추가"
}

enum TodoContentsMemos: String, CaseIterable {
    case title = "제목"
    case memos = "메모"
}
