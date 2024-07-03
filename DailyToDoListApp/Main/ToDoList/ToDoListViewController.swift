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
    var list: Results<Todo>!
    
    override func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
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
        toDoListTableView.rowHeight = 120
    }
    
    func configureNavigationBar(sortType: SortType) {
        navigationItem.title = sortType.rawValue
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.id, for: indexPath) as! ToDoListTableViewCell
        let data = list[indexPath.row]
        cell.backgroundColor = .gray
        cell.configureTableViewCellUI(title: data.title, memo: data.memo ?? "", date: data.date, hashtag: data.hashTag ?? "")

        return cell
    }
}
