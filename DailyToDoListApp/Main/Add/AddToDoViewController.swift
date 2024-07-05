//
//  AddToDoViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit

protocol ToDoContentsDelegate {
    func sendHashTag(hashtag: String)
    func sendDeadline(date: Date)
    func sendImportantValue(importantValue: Int)
    func sendImage(image: UIImage?)
}

final class AddToDoViewController: BaseViewController {
    private lazy var elementStackView = UIStackView(arrangedSubviews: [contentsStackView, deadlineButton, hashTagButton, importantValueButton, addImageButton])
    private lazy var contentsStackView = UIStackView(arrangedSubviews: [titleTextField, divider, memoTextView])
    private let titleTextField = UITextField()
    private let divider = DividerLine()
    private let memoTextView = UITextView()
    private let deadlineButton = ToDoElementButton(TodoContents.deadline)
    private let hashTagButton = ToDoElementButton(TodoContents.hashTag)
    private let importantValueButton = ToDoElementButton(TodoContents.isImortant)
    private let addImageButton = ToDoElementButton(TodoContents.addImage)
    
    private let realm = try! Realm()
    
    var sendData: (() -> Void)?
    
    private var image: UIImage?
    private var titleText: String?
    private var memo: String?
    private var hashtag: String?
    private var deadline: Date?
    private var importantValue: Int?
    
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
            if let title = titleText {
                memo = memoTextView.text
                let todo = ToDo(title: title, memo: memo ?? nil, hashTag: hashtag ?? "", date: Date(), deadline: deadline ?? Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: Date())), importantValue: importantValue ?? 1)
                
                realm.add(todo)
                sendData?()
            }
        }

        dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(contentsStackView)
        view.addSubview(elementStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func configureLayout() {
        elementStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(15)
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
            make.horizontalEdges.equalTo(elementStackView.snp.horizontalEdges).inset(15)
            make.height.equalTo(45)
        }
        
        hashTagButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
        }
        
        importantValueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
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
        buttonAddTarget(hashTagButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(importantValueButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(addImageButton, self, action: #selector(todoClicked(_:)))
    }
    
    @objc private func todoClicked(_ sender: UIButton) {
        let data = TodoContents.allCases[sender.tag]
        switch data {
            
        case .deadline:
            let vc = SetDeadLineVIewController()
            vc.beforeView = self
            
            if let deadline = self.deadline {
                vc.datePicker.date = deadline
                
                let formatDateStr = DateFormatter.customDateFormatter(date: deadline)
                vc.deadlineLabel.text = formatDateStr
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .hashTag:
            let vc = SetHashTagViewController()
            vc.beforeVC = self
            if let text = hashtag {
                vc.hashTagTextField.text = text
                vc.hashTagLabel.text = hashTagButton.todoDataLabel.text
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .isImortant:
            let vc = SetImportantValueViewController()
            vc.beforeVC = self
            if let value = importantValue {
                vc.importantValue = value
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .addImage:
            let imagePicker = SetImageViewController()
            imagePicker.beforeVC = self
            navigationController?.pushViewController(imagePicker, animated: true)
            
        default:
            let vc = UIViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension AddToDoViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let title = textField.text {
            if title.trimmingCharacters(in: .whitespaces).isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                titleText = title
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}

extension AddToDoViewController: ToDoContentsDelegate {
    
    func sendHashTag(hashtag: String) {
        self.hashtag = hashtag
        hashTagButton.todoDataLabel.text = hashtag.isEmpty ? nil : "#" + hashtag
    }
    
    func sendDeadline(date: Date) {
        self.deadline = date
        let formatDateStr = DateFormatter.customDateFormatter(date: date)
        deadlineButton.todoDataLabel.text = formatDateStr
    }
    
    func sendImportantValue(importantValue: Int) {
        self.importantValue = importantValue
        print(self.importantValue)
        importantValueButton.todoDataLabel.text = ImportantVlue.allCases[importantValue].rawValue
    }
    
    func sendImage(image: UIImage?) {
        self.image = image
        
        addImageButton.todoDataLabel.text = self.image == nil ? nil : "이미지 추가 완료!"
    }
}
