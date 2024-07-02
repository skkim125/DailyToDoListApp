//
//  TitleTFTableViewCell.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import UIKit

final class TitleTFTableViewCell: BaseTableViewCell {
    let titleTextField = UITextField()
    
    override func configureHierarchy() {
        contentView.addSubview(titleTextField)
    }
    
    override func configureView() {
        titleTextField.backgroundColor = .clear
        contentView.backgroundColor = .systemGray5
    }

    
    func configureContentViewCell() {
        titleTextField.placeholder = "제목"
        titleTextField.font = .systemFont(ofSize: 20)
        
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
}
