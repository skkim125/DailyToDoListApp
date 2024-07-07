//
//  ToDoRepository.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/7/24.
//

import Foundation
import RealmSwift

class ToDoRepository {
    private let realm = try! Realm()
    
    func loadToDoList() -> Results<ToDo> {
        return realm.objects(ToDo.self)
    }
    
    func addToDo(todo: ToDo) {
        do {
            try realm.write {
                realm.add(todo)
                print("ToDo 추가 성공")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func removeToDo(todo: ToDo) {
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func updateToDo<T>(toDo: ToDo, data: String, value: T) {
        do {
            try realm.write {
                realm.create(ToDo.self, value:
                                ["id": toDo.id,
                                 "\(data)": value
                                ],
                             update: .modified
                )
            }
        } catch {
            print("Realm Error")
        }
    }
}
