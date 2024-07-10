//
//  AddMyFolderViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import UIKit
import SnapKit

class AddMyFolderViewController: BaseViewController {
    private lazy var setFolderUIView = UIView()
    private let folderImage = UIImageView()
    private lazy var folderTextFieldView = {
       let view = UIView()
        view.addSubview(folderTextField)
        
        return view
    }()
    private let folderTextField = UITextField()
    
    private lazy var colorPickerView = UIView()
    private let redColor = ColorButton(color: FolderColor.red.rawValue, buttonType: .custom)
    private let blueColor = ColorButton(color: FolderColor.blue.rawValue, buttonType: .custom)
    private let greenColor = ColorButton(color: FolderColor.green.rawValue, buttonType: .custom)
    private let orangeColor = ColorButton(color: FolderColor.orange.rawValue, buttonType: .custom)
    
    private let myFolderRepository = MyFolderRepository()
    private var titleText: String?
    private var color: String?
    var sendData: (()->Void)?
    
    override func configureNavigationBar() {
        navigationItem.title = "새로운 목록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonClicked() {
        if let title = folderTextField.text {
            let folder = Folder(title: title, color: color ?? FolderColor.blue.rawValue)
            myFolderRepository.addFolder(folder: folder)
            sendData?()
        }
        
        dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(setFolderUIView)
        setFolderUIView.addSubview(folderImage)
        setFolderUIView.addSubview(folderTextFieldView)
        view.addSubview(colorPickerView)
        view.addSubview(redColor)
        view.addSubview(blueColor)
        view.addSubview(greenColor)
        view.addSubview(orangeColor)
    }
    
    override func configureLayout() {
        setFolderUIView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(210)
        }
        
        folderImage.snp.makeConstraints { make in
            make.top.equalTo(setFolderUIView.snp.top).offset(20)
            make.centerX.equalTo(view)
            make.size.equalTo(90)
        }
        
        folderTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(folderImage.snp.bottom).offset(20)
            make.bottom.equalTo(setFolderUIView.snp.bottom).inset(20)
            make.horizontalEdges.equalTo(setFolderUIView).inset(20)
        }
        
        folderTextField.snp.makeConstraints { make in
            make.edges.equalTo(folderTextFieldView.snp.edges).inset(20)
            make.height.equalTo(30)
        }
        
        colorPickerView.snp.makeConstraints { make in
            make.top.equalTo(setFolderUIView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(80)
        }
        
        redColor.snp.makeConstraints { make in
            make.leading.equalTo(colorPickerView.snp.leading)
            make.centerY.equalTo(colorPickerView.snp.centerY)
            make.width.equalTo(colorPickerView.snp.width).multipliedBy(0.25)
            make.height.equalTo(50)
        }
        
        blueColor.snp.makeConstraints { make in
            make.leading.equalTo(redColor.snp.trailing)
            make.centerY.equalTo(colorPickerView.snp.centerY)
            make.width.equalTo(colorPickerView.snp.width).multipliedBy(0.25)
            make.height.equalTo(50)
        }
        
        greenColor.snp.makeConstraints { make in
            make.leading.equalTo(blueColor.snp.trailing)
            make.centerY.equalTo(colorPickerView.snp.centerY)
            make.width.equalTo(colorPickerView.snp.width).multipliedBy(0.25)
            make.height.equalTo(50)
        }
        
        orangeColor.snp.makeConstraints { make in
            make.leading.equalTo(greenColor.snp.trailing)
            make.centerY.equalTo(colorPickerView.snp.centerY)
            make.width.equalTo(colorPickerView.snp.width).multipliedBy(0.25)
            make.trailing.equalTo(colorPickerView.snp.trailing)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        setFolderUIView.backgroundColor = .systemGray5
        setFolderUIView.layer.cornerRadius = 12
        setFolderUIView.clipsToBounds = true
        
        folderImage.image = UIImage(systemName: "list.bullet.circle.fill")
        folderImage.contentMode = .scaleAspectFit
        
        folderTextFieldView.backgroundColor = .systemGray3
        folderTextFieldView.layer.cornerRadius = 12
        folderTextFieldView.clipsToBounds = true
        folderTextField.delegate = self
        
        folderTextField.placeholder = "목록 이름"
        folderTextField.font = .boldSystemFont(ofSize: 24)
        folderTextField.textAlignment = .center
        
        colorPickerView.backgroundColor = .systemGray5
        colorPickerView.layer.cornerRadius = 12
        colorPickerView.clipsToBounds = true
        
        
        buttonAddTarget(redColor, self, action: #selector(colorButtonClicked(_:)))
        buttonAddTarget(blueColor, self, action: #selector(colorButtonClicked(_:)))
        buttonAddTarget(greenColor, self, action: #selector(colorButtonClicked(_:)))
        buttonAddTarget(orangeColor, self, action: #selector(colorButtonClicked(_:)))
    }
    
    @objc func colorButtonClicked(_ sender: ColorButton) {
        folderImage.tintColor = sender.tintColor
        color = sender.color
    }
}

extension AddMyFolderViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        titleText = textField.text
        if let title = titleText {
            if title.trimmingCharacters(in: .whitespaces).isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}
