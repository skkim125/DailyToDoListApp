//
//  SetHashTagViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit
import SnapKit

final class SetHashTagViewController: BaseViewController {
    private let textfieldLine = DividerLine()
    private let hashTagLabel = UILabel()
    private let hashTagTextField = UITextField()
    
    var beforeVC: AddToDoViewController?
    var viewModel: ToDoViewModel?
    
    override func configureHierarchy() {
        view.addSubview(hashTagTextField)
        view.addSubview(textfieldLine)
        view.addSubview(hashTagLabel)
    }
    
    func bindData() {
        if let vm = viewModel {
            hashTagTextField.text = vm.inputHashtagText.value
            hashTagLabel.text = vm.outputHashtagText.value
        }
    }
    
    override func configureLayout() {
        hashTagLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        
        hashTagTextField.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
        }
        
        textfieldLine.snp.makeConstraints { make in
            make.top.equalTo(hashTagTextField.snp.bottom).offset(1)
            make.horizontalEdges.equalTo(hashTagTextField)
            make.height.equalTo(1)
        }
    }
    
    override func configureView() {
        hashTagTextField.borderStyle = .none
        hashTagTextField.placeholder = "해시태그를 입력하세요."
        hashTagTextField.autocorrectionType = .no
        hashTagTextField.autocapitalizationType = .none
        hashTagTextField.delegate = self
        
        hashTagLabel.textAlignment = .center
        hashTagLabel.textColor = .systemOrange
        hashTagLabel.font = .boldSystemFont(ofSize: 20)
        
        if let vm = viewModel {
            hashTagTextField.text = vm.inputHashtagText.value
            hashTagLabel.text = vm.outputHashtagText.value
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let vc = beforeVC {
            vc.sendHashTag()
        }
    }
}

extension SetHashTagViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let vm = viewModel {
            guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                vm.inputHashtagText.value = nil
                vm.outputHashtagText.value = nil
                
                bindData()
                return
            }
            
            vm.inputHashtagText.value = text
            
            bindData()
        }
    }
}
