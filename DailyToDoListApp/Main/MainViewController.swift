//
//  MainViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class MainViewController: BaseViewController {
    
    private let todoListTableView = UITableView()
    private let addTodoButton = UIButton()
    
    private let realm = try! Realm()
    
    override func configureNavigationBar() {
        navigationItem.title = "오늘 할 일"
    }
    
    override func configureHierarchy() {
        view.addSubview(addTodoButton)
        view.addSubview(todoListTableView)
    }
    
    override func configureLayout() {
        addTodoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        todoListTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(addTodoButton.snp.top)
        }
    }
    
    override func configureView() {
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.id)
        todoListTableView.separatorInset = .zero
        
        addTodoButton.setTitle("새로운 할 일", for: .normal)
        addTodoButton.setTitleColor(.blue, for: .normal)
        addTodoButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        addTodoButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addTodoButton.imageView?.contentMode = .scaleAspectFit
        addTodoButton.tintColor = .blue
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
    }
    
    @objc private func addTodoButtonClicked() {
        let nav = UINavigationController(rootViewController: AddToDoViewController())
        
        present(nav, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.id, for: indexPath) as! ToDoListTableViewCell
        cell.backgroundColor = .green
        
        return cell
    }
}
