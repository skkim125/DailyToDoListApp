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
    
    private let toDoRepository = ToDoRepository()
    var list: [ToDo]?
    var beforeVC: MainViewController?
    
    
    override func configureNavigationBar() {
        let defaultSort = UIAction(title: SortType.defualt.rawValue, image: UIImage(systemName: "clock"), handler: { _ in
            self.sortOfDefault()
        })
        
        let sortofImportant = UIAction(title: SortType.importantValue.rawValue, image: UIImage(systemName: "1.circle"), handler: { _ in self.sortOfImportantValue()
        })
        
        let sortofDeadline = UIAction(title: SortType.deadline.rawValue, image: UIImage(systemName: "calendar.badge.checkmark"), handler: { _ in
            self.sortOfDeadLine()
        })
                                   
        let menus = UIMenu(title: "정렬 기준", options: .displayInline, children: [defaultSort, sortofImportant, sortofDeadline])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), menu: menus)
    }
    
    private func sortOfDefault() {
        list = list?.sorted(by: { $0.date > $1.date })
        toDoListTableView.reloadData()
    }
    
    private func sortOfImportantValue() {
        list = list?.sorted(by: { $0.importantValue > $1.importantValue })
        toDoListTableView.reloadData()
    }
    
    private func sortOfDeadLine() {
        list = list?.sorted(by: { $0.deadline > $1.deadline })
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
    
    func configureNavigationBar(sortType: ListSortType) {
        navigationItem.title = sortType.rawValue
    }

    
    private func updateVC(_ tv: UITableView) {
        if let vc = self.beforeVC {
            UITableView.reloadView(cv: vc.collectionView, tv: tv)
        }
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.id, for: indexPath) as! ToDoListTableViewCell
        guard let data = list?[indexPath.row] else { return cell }
        
        cell.configureTableViewCellUI(data: data)
        cell.isDoneClosure = { before in
            var after = before
            after.toggle()
            
            self.toDoRepository.updateToDo(toDo: data, data: "isDone", value: after)
            self.updateVC(tableView)
            
            return after
        }
        cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let data = list?[indexPath.row] else { return nil }
        
        let edit = UIContextualAction(style: .normal, title: data.isFlaged ? "깃발 해제" : "깃발 표시") { (action, view, success: @escaping (Bool) -> Void) in
            
            var isFlaged = data.isFlaged
            isFlaged.toggle()
            
            self.toDoRepository.updateToDo(toDo: data, data: "isFlaged", value: isFlaged)
            self.updateVC(tableView)
            
            success(true)
        }
        
        edit.backgroundColor = .systemOrange
        edit.image = UIImage(systemName: data.isFlaged ? "flag.slash.fill" : "flag.fill")
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, success: @escaping (Bool) -> Void) in
            
            self.toDoRepository.removeToDo(todo: data)
            self.updateVC(tableView)
            
            success(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions:[delete, edit])
    }
}
