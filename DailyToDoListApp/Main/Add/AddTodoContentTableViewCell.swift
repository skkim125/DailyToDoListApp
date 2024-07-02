//
//  AddTodoContentTableView.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit

final class AddTodoContentTableViewCell: BaseTableViewCell {
    private let titleLabel = UITextField()
    private let memoTextView = UITextView()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoTextView)
    }
    
    override func configureView() {
        titleLabel.backgroundColor = .clear
        memoTextView.backgroundColor = .clear
        contentView.backgroundColor = .systemGray5
    }

    
    func configureContentViewCell() {
        titleLabel.placeholder = "제목"
        titleLabel.font = .systemFont(ofSize: 20)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureMemoTextView() {
        memoTextView.font = .systemFont(ofSize: 16)
        
        memoTextView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(15)
            make.trailing.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
