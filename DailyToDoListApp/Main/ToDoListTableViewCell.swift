//
//  ToDoListTableViewCell.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit

final class ToDoListTableViewCell: BaseTableViewCell {
    
    private let todoTitleLabel = UILabel()
    private let memoLabel = UILabel()
    private let dateLabel = UILabel()
    private let hashtagLabel = UILabel()
    
    
    override func configureHierarchy() {
        contentView.addSubview(todoTitleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(hashtagLabel)
    }
    
    override func configureLayout() {
        todoTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(40)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(todoTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(20)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(5)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5)
            make.height.equalTo(20)
        }
    }
    
    func configureTableViewCellUI(title: String, memo: String, date: Date, hashtag: String) {
        todoTitleLabel.text = title
        memoLabel.text = memo
        dateLabel.text = "\(date)"
        hashtagLabel.text = hashtag
    }
    
}
