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
    @Persisted var content: String?
    @Persisted var hashTag: String?
    @Persisted var date: Date
    @Persisted(indexed: true) var deadline: Date
    @Persisted(indexed: true) var isImportant: Bool
    @Persisted var isEnd: Bool
    
    convenience init(title: String, content: String?, hashTag: String?, date: Date, deadline: Date, isImportant: Bool) {
        self.init()
        self.title = title
        self.content = content
        self.hashTag = hashTag
        self.date = date
        self.deadline = deadline
        self.isImportant = isImportant
        self.isEnd = false
    }
}
