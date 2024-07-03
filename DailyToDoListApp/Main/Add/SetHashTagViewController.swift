//
//  SetHashTagViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit
import SnapKit

class SetHashTagViewController: BaseViewController {
    let hashTagLabel = UILabel()
    let hashTagTextField = UITextField()
    var beforeVC: AddToDoViewController?
    
    override func configureHierarchy() {
        view.addSubview(hashTagTextField)
        view.addSubview(hashTagLabel)
    }
    
    override func configureLayout() {
        hashTagTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(hashTagTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        hashTagTextField.borderStyle = .roundedRect
        hashTagTextField.autocorrectionType = .no
        hashTagTextField.autocapitalizationType = .none
        hashTagTextField.delegate = self
        
        hashTagLabel.textAlignment = .center
        hashTagLabel.textColor = .systemOrange
        hashTagLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(hashTagLabel.text ?? "")
        if let vc = beforeVC, let hashtag = hashTagTextField.text, !hashtag.trimmingCharacters(in: .whitespaces).isEmpty {
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
