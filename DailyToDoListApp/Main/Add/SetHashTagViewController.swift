//
//  SetHashTagViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit
import SnapKit

final class SetHashTagViewController: BaseViewController {
    let hashTagLabel = UILabel()
    let hashTagTextField = UITextField()
    let textfieldLine = DividerLine()
    var beforeVC: AddToDoViewController?
    
    override func configureHierarchy() {
        view.addSubview(hashTagTextField)
        view.addSubview(textfieldLine)
        view.addSubview(hashTagLabel)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(hashTagLabel.text ?? "")
        if let vc = beforeVC, let hashtag = hashTagTextField.text {
            vc.sendHashTag(hashtag: hashtag)
        }
    }
}

extension SetHashTagViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            hashTagLabel.text = nil
            return
        }
        hashTagLabel.text = "#" + hashTagTextField.text!
    }
}
