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
    private lazy var elementStackView = UIStackView(arrangedSubviews: [contentsStackView, deadlineButton, tagButton, isImportantButton, addImageButton])
    private lazy var contentsStackView = UIStackView(arrangedSubviews: [titleTextField, divider, memoTextView])
    private let titleTextField = UITextField()
    private let divider = DividerLine()
    private let memoTextView = UITextView()
    private let deadlineButton = ToDoElementButton(TodoContents.deadline)
    private let tagButton = ToDoElementButton(TodoContents.tag)
    private let isImportantButton = ToDoElementButton(TodoContents.isImortant)
    private let addImageButton = ToDoElementButton(TodoContents.addImage)
    
    private let realm = try! Realm()
    
    var sendData: (() -> Void)?
    
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
            if let titleText = titleTextField.text {
                let todo = Todo(title: titleText, memo: memoTextView.text, hashTag: "테스트", date: Date(), deadline: Date(), isImportant: false, image: "테스트")
                
                realm.add(todo)
                sendData?()
            }
        }

        dismiss(animated: true)
    }
    
    func isSaveButtonEnable() {
        
        if let title = titleTextField.text {
            if title.trimmingCharacters(in: .whitespaces).isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(contentsStackView)
        view.addSubview(elementStackView)
    }
    
    override func configureLayout() {
        elementStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(140)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentsStackView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(contentsStackView.snp.leading).offset(20)
            make.trailing.equalTo(contentsStackView.snp.trailing)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.leading.equalTo(contentsStackView.safeAreaLayoutGuide).inset(15)
            make.trailing.equalTo(contentsStackView.safeAreaLayoutGuide).inset(10)
        }
        
        deadlineButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.snp.horizontalEdges).inset(20)
            make.height.equalTo(50)
        }
        
        tagButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        isImportantButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        contentsStackView.axis = .vertical
        contentsStackView.alignment = .center
        contentsStackView.backgroundColor = .systemGray5
        contentsStackView.layer.cornerRadius = 8
        
        titleTextField.delegate = self
        titleTextField.placeholder = "제목"
        titleTextField.font = .boldSystemFont(ofSize: 18)
        
        memoTextView.backgroundColor = .clear
        memoTextView.font = .systemFont(ofSize: 17)
        
        elementStackView.axis = .vertical
        elementStackView.spacing = 20
        elementStackView.alignment = .center
        
        buttonAddTarget(deadlineButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(tagButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(isImportantButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(addImageButton, self, action: #selector(todoClicked(_:)))
    }
    
    @objc func todoClicked(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            let vc = UIViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = UIViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = UIViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension AddToDoViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isSaveButtonEnable()
    }
}
