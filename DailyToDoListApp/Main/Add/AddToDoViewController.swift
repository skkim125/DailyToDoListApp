//
//  AddToDoViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit

final class AddToDoViewController: BaseViewController {
    private let tableView = UITableView()
    private var titleText: String?
    private var memo: String?
    private let realm = try! Realm()
    
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
        try! realm.write {
            if let titleText = titleText {
                let todo = Todo(title: titleText, memo: "memo", hashTag: "테스트", date: Date(), deadline: Date(), isImportant: false, image: "테스트")
                
                realm.add(todo)
            }
        }

        dismiss(animated: true)
    }
    
    func isSaveButtonEnable() {
        
        if let title = titleText {
            if title.trimmingCharacters(in: .whitespaces).isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print(titleText ?? "타이틀 입력 오류")
        print(memo ?? "메모 입력 오류")
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
            
            if let ttfCell = cell.contentsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TitleTFTableViewCell {
                ttfCell.titleTextField.delegate = self
            }
            
            if let textViewCell = cell.contentsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? MemoTextViewTableViewCell {
                textViewCell.memoTextView.delegate = self
            }
            
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

extension AddToDoViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.text)
        titleText = textField.text
        isSaveButtonEnable()
        if let title = titleText {
            print(title)
        }
    }
}

extension AddToDoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let numberOfLines = Int(estimatedSize.height / (textView.font!.lineHeight))
        
        textView.constraints.forEach { constraint in
            
            if constraint.firstAttribute == .height && numberOfLines <= 4{
                constraint.constant = estimatedSize.height
            } else if numberOfLines > 4 {
                textView.isScrollEnabled = true
            }
        }
        memo = textView.text!
        print(memo)
    }
}
