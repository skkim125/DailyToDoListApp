//
//  Folder.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var color: String
    
    @Persisted var todo: List<ToDo>
}
