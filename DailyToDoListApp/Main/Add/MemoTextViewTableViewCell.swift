//
//  AddTodoContentTableView.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit

final class MemoTextViewTableViewCell: BaseTableViewCell {
    let memoTextView = UITextView()
    
    override func configureHierarchy() {
        contentView.addSubview(memoTextView)
    }
    
    override func configureView() {
        memoTextView.backgroundColor = .clear
        contentView.backgroundColor = .systemGray5
    }
    
    func configureMemoTextView() {
        memoTextView.font = .systemFont(ofSize: 16)
        
        memoTextView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(15)
            make.trailing.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
