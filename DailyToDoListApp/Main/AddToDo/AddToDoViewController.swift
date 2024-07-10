//
//  AddToDoViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit

protocol ToDoContentsDelegate {
    func sendHashTag()
    func sendDeadline()
    func sendImportantValue()
    func sendImage(image: UIImage?)
}

final class AddToDoViewController: BaseViewController {
    private lazy var elementStackView = UIStackView(arrangedSubviews: [contentsStackView, deadlineButton, hashTagButton, importantValueButton, selectImageView, addImageButton])
    private lazy var contentsStackView = UIStackView(arrangedSubviews: [titleTextField, divider, memoTextView])
    private let titleTextField = UITextField()
    private let memoTextViewPlaceholder = UILabel()
    private let divider = DividerLine()
    private let memoTextView = UITextView()
    private let deadlineButton = MenuButtonUI()
    private let hashTagButton = MenuButtonUI()
    private let importantValueButton = MenuButtonUI()
    private let addImageButton = MenuButtonUI()
    private let selectImageView = UIImageView()
    private let imageRemoveButton = UIButton(type: .system)
    
    private let toDoRepository = ToDoRepository()
    
    private var titleText: String?
    var viewModel = ToDoViewModel()
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
        if let title = titleText {
            let todo = ToDo(title: title, memo: viewModel.inputTextViewText.value ?? "", hashTag: viewModel.inputHashtagText.value ?? "", date: Date(), deadline: Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: viewModel.inputDate.value ?? Date())), importantValue: viewModel.inputImportantValue.value ?? 1)
            
            toDoRepository.addToDo(todo: todo)
            if let image = selectImageView.image {
                ImageManager.shared.saveImageToDocument(image: image, filename: "\(todo.id)")
            } else {
                ImageManager.shared.saveImageToDocument(image: UIImage(systemName: "photo.artframe")!, filename: "\(todo.id)")
            }
            sendData?()
        }
        
        dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(contentsStackView)
        view.addSubview(elementStackView)
        view.addSubview(imageRemoveButton)
        view.addSubview(memoTextViewPlaceholder)
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
        
        memoTextViewPlaceholder.snp.makeConstraints { make in
            make.top.equalTo(memoTextView).inset(8)
            make.leading.equalTo(memoTextView).inset(5)
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
        
        selectImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(150)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(elementStackView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
        }
        
        imageRemoveButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.top.equalTo(selectImageView.snp.top).inset(-8)
            make.trailing.equalTo(selectImageView.snp.trailing).offset(8)
        }
    }
    
    func bindData() {
        viewModel.outputhiddenLabel.bind { isHidden in
            self.memoTextViewPlaceholder.isHidden = isHidden
        }
    }
    
    override func configureView() {
        contentsStackView.axis = .vertical
        contentsStackView.alignment = .center
        contentsStackView.backgroundColor = .systemGray5
        contentsStackView.layer.cornerRadius = 12
        
        titleTextField.delegate = self
        titleTextField.placeholder = "제목"
        titleTextField.font = .boldSystemFont(ofSize: 18)
        
        memoTextView.backgroundColor = .clear
        memoTextView.font = .systemFont(ofSize: 17)
        memoTextView.delegate = self
        
        elementStackView.axis = .vertical
        elementStackView.spacing = 20
        elementStackView.alignment = .center
        
        deadlineButton.getButtonTag(element: .deadline)
        deadlineButton.configureButtonText(title: TodoContents.deadline.rawValue)
        hashTagButton.getButtonTag(element: .hashTag)
        hashTagButton.configureButtonText(title: TodoContents.hashTag.rawValue)
        importantValueButton.getButtonTag(element: .importantValue)
        importantValueButton.configureButtonText(title: TodoContents.importantValue.rawValue)
        addImageButton.getButtonTag(element: .addImage)
        addImageButton.configureButtonText(title: TodoContents.addImage.rawValue)
        
        
        buttonAddTarget(deadlineButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(hashTagButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(importantValueButton, self, action: #selector(todoClicked(_:)))
        buttonAddTarget(addImageButton, self, action: #selector(todoClicked(_:)))
        
        selectImageView.layer.cornerRadius = 12
        selectImageView.clipsToBounds = true
        selectImageView.layer.borderColor = UIColor.lightGray.cgColor
        selectImageView.layer.borderWidth = 0.5

        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .systemRed])
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        imageRemoveButton.setImage(image, for: .normal)
        imageRemoveButton.tintColor = .white
        imageRemoveButton.addTarget(self, action: #selector(removeImageButtonClicked), for: .touchUpInside)
        
        memoTextViewPlaceholder.text = "메모를 입력해주세요"
        memoTextViewPlaceholder.textColor = .gray
        bindData()
    }
    
    @objc private func removeImageButtonClicked() {
        selectImageView.image = nil
        showImageView()
    }
    
    @objc private func todoClicked(_ sender: UIButton) {
        let data = TodoContents.allCases[sender.tag]
        switch data {
            
        case .deadline:
            let vc = SetDeadLineViewController()
            vc.beforeView = self
            vc.viewModel = self.viewModel
            
            navigationController?.pushViewController(vc, animated: true)
            
        case .hashTag:
            let vc = SetHashTagViewController()
            vc.beforeVC = self
            vc.viewModel = self.viewModel
            
            navigationController?.pushViewController(vc, animated: true)
            
        case .importantValue:
            let vc = SetImportantValueViewController()
            vc.beforeVC = self
            vc.viewModel = self.viewModel
            
            navigationController?.pushViewController(vc, animated: true)
            
        case .addImage:
            let imagePicker = SetImageViewController()
            imagePicker.beforeVC = self
            navigationController?.pushViewController(imagePicker, animated: true)
        }
    }
    
    private func showImageView() {
        selectImageView.isHidden = (selectImageView.image == nil) ? true : false
        imageRemoveButton.isHidden = (selectImageView.image == nil) ? true : false
        addImageButton.todoDataLabel.text = (selectImageView.image == nil) ? nil : "이미지 추가 완료!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        showImageView()
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

extension AddToDoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.inputTextViewText.value = textView.text
    }
}

extension AddToDoViewController: ToDoContentsDelegate {
    
    func sendHashTag() {
        hashTagButton.todoDataLabel.text = viewModel.outputHashtagText.value
    }
    
    func sendDeadline() {
        deadlineButton.todoDataLabel.text = viewModel.outputDateLabelText.value
    }
    
    func sendImportantValue() {
        importantValueButton.todoDataLabel.text = viewModel.outputImportantValueText.value
    }
    
    func sendImage(image: UIImage?) {
        selectImageView.image = image
        showImageView()
    }
}
