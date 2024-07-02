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
    
    let todoListTableView = UITableView()
    private let addTodoButton = UIButton()
    private let isEmptyLabel = UILabel()
    
    private let realm = try! Realm()
    private var list: Results<Todo>!
    
    override func configureNavigationBar() {
        navigationItem.title = "오늘 할 일"
    }
    
    override func configureHierarchy() {
        view.addSubview(addTodoButton)
        view.addSubview(isEmptyLabel)
        view.addSubview(todoListTableView)
    }
    
    override func configureLayout() {
        addTodoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        isEmptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
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
        todoListTableView.rowHeight = 120
        
        isEmptyLabel.text = "할 일을 추가하세요!"
        isEmptyLabel.font = .boldSystemFont(ofSize: 18)
        isEmptyLabel.textAlignment = .center
        
        addTodoButton.setTitle("새로운 할 일", for: .normal)
        addTodoButton.setTitleColor(.blue, for: .normal)
        addTodoButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        addTodoButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addTodoButton.imageView?.contentMode = .scaleAspectFit
        addTodoButton.tintColor = .blue
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
        
        list = realm.objects(Todo.self)
    }
    
    @objc private func addTodoButtonClicked() {
        let vc = AddToDoViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showView()
        print("뷰 나오는 중")
    }
    
    private func showView() {
        isEmptyLabel.isHidden = list.isEmpty ? false : true
        todoListTableView.isHidden = list.isEmpty ? true : false
        
        if !list.isEmpty {
            todoListTableView.reloadData()
            print("갱신")
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
