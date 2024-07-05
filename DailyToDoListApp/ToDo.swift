//
//  ToDo.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var memo: String?
    @Persisted var hashTag: String?
    @Persisted var date: Date
    @Persisted(indexed: true) var deadline: Date
    @Persisted(indexed: true) var importantValue: Int
    @Persisted var isDone: Bool
    @Persisted var isFlaged: Bool
    
    convenience init(title: String, memo: String?, hashTag: String?, date: Date, deadline: Date, importantValue: Int) {
        self.init()
        self.title = title
        self.memo = memo
        self.hashTag = hashTag
        self.date = date
        self.deadline = deadline
        self.importantValue = importantValue
        self.isDone = false
        self.isFlaged = false
    }
}
