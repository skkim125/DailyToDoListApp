//
//  FolderRepository.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import Foundation
import RealmSwift

class MyFolderRepository {
    private let realm = try! Realm()
    
    func loadURL() {
        print(realm.configuration.fileURL)
    }
    
    func loadMyFolder() -> Results<Folder> {
        return realm.objects(Folder.self)
    }
    
    func addToDo(folder: Folder) {
        do {
            try realm.write {
                realm.add(folder)
                print("Folder 추가 성공")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func removeToDo(folder: Folder) {
        do {
            try realm.write {
                realm.delete(folder)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func updateValue<T>(folder: Folder, data: String, value: T) {
        do {
            try realm.write {
                realm.create(Folder.self, value:
                                ["id": folder.id,
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
