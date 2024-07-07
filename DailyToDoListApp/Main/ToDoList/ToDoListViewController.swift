//
//  ToDoListViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ToDoListViewController: BaseViewController {
    private let toDoListTableView = UITableView()
    private var realm = try! Realm()
    private var list: Results<ToDo>!
    var beforeVC: MainViewController?
    
    
    override func configureNavigationBar() {
        let defaultSort = UIAction(title: "최근추가순", image: UIImage(systemName: "clock"), handler: { _ in
            self.sortOfDefault()
        })
        
        let sortofImportant = UIAction(title: "우선순위순", image: UIImage(systemName: "1.circle"), handler: { _ in self.sortOfImportantValue()
        })
        
        let sortofDeadline = UIAction(title: "마감일자순", image: UIImage(systemName: "calendar.badge.checkmark"), handler: { _ in
            self.sortOfDeadLine()
        })
                                   
        let menus = UIMenu(title: "정렬 기준", options: .displayInline, children: [defaultSort, sortofImportant, sortofDeadline])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), menu: menus)
    }
    
    private func sortOfDefault() {
        list = list.sorted(byKeyPath: "date", ascending: true)
        toDoListTableView.reloadData()
    }
    
    private func sortOfImportantValue() {
        list = list.sorted(byKeyPath: "importantValue", ascending: false)
        toDoListTableView.reloadData()
    }
    
    private func sortOfDeadLine() {
        list = list.sorted(byKeyPath: "deadline", ascending: true)
        toDoListTableView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(toDoListTableView)
    }
    
    override func configureLayout() {
        toDoListTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        toDoListTableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.id)
        toDoListTableView.rowHeight = 100
    }
    
    func configureNavigationBar(sortType: SortType) {
        navigationItem.title = sortType.rawValue
    }
    
    func configureSetList(list: Results<ToDo>) {
        self.list = list
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.id, for: indexPath) as! ToDoListTableViewCell
        let data = list[indexPath.row]
        
        cell.configureTableViewCellUI(data: data)
        cell.isDoneClosure = { before in
            var after = before
            after.toggle()
            
            let realm = try! Realm()
            print(data.id)
            do {
                try realm.write {
                    realm.create(ToDo.self,
                                 value: ["id": data.id ,
                                        "isDone": after],
                                 update: .modified)
                }
            } catch {
                print("Error")
            }
            
            tableView.reloadData()
            if let vc = self.beforeVC {
                vc.collectionView.reloadData()
            }
            return after
        }
        cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let data = list[indexPath.row]
        var flaged = data.isFlaged
        flaged.toggle()
        
        
        let edit = UIContextualAction(style: .normal, title: data.isFlaged ? "깃발 해제" : "깃발 표시") { (action, view, success: @escaping (Bool) -> Void) in
            
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.create(ToDo.self,
                                 value: ["id": data.id ,
                                        "isFlaged": flaged],
                                 update: .modified)
                }
            } catch {
                print("Error")
            }
            
            if let vc = self.beforeVC {
                vc.collectionView.reloadData()
                tableView.reloadData()
            }
            success(true)
        }
        
        edit.backgroundColor = .systemOrange
        edit.image = UIImage(systemName: data.isFlaged ? "flag.slash.fill" : "flag.fill")
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, success: @escaping (Bool) -> Void) in
            success(true)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions:[delete, edit])
    }
}
