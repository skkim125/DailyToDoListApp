//
//  AddToDoViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit

final class AddToDoViewController: BaseViewController {
    private let tableView = UITableView()
    
    override func configureNavigationBar() {
        navigationItem.title = "새로운 할 일"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonClicked() {
        
        
        
        dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddTodoTableViewCell.self, forCellReuseIdentifier: AddTodoTableViewCell.id)
        tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: ContentsTableViewCell.id)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
}
extension AddToDoViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 180 : 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoContents.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.id, for: indexPath) as! ContentsTableViewCell
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = true
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTodoTableViewCell.id, for: indexPath) as! AddTodoTableViewCell
            
            cell.selectionStyle = .none
            cell.configureButtonUI(text: TodoContents.allCases[indexPath.row].rawValue)
            cell.isUserInteractionEnabled = true
            
            return cell
        }
    }
}
