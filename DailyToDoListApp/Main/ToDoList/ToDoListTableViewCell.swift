//
//  ToDoListTableViewCell.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import UIKit
import SnapKit

final class ToDoListTableViewCell: BaseTableViewCell {
    private let isDoneButton = UIButton()
    private let todoTitleLabel = UILabel()
    private let memoLabel = UILabel()
    private let dateLabel = UILabel()
    private let hashtagLabel = UILabel()
    private let flagImageView = UIImageView()
    
    private var isDone: Bool = false
    private var todo: ToDo?
    var isDoneClosure: ((Bool)->Bool)?
    
    override func configureHierarchy() {
        contentView.addSubview(isDoneButton)
        contentView.addSubview(todoTitleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(hashtagLabel)
        contentView.addSubview(flagImageView)
    }
    
    override func configureLayout() {
        
        isDoneButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(30)
        }
        
        flagImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(20)
        }
        
        todoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(isDoneButton.snp.trailing).offset(15)
            make.trailing.equalTo(flagImageView.snp.leading).inset(10)
            make.height.equalTo(30)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(todoTitleLabel.snp.bottom).offset(2)
            make.leading.equalTo(isDoneButton.snp.trailing).offset(15)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(25)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(2)
            make.leading.equalTo(isDoneButton.snp.trailing).offset(15)
            make.height.equalTo(25)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(2)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5)
            make.height.equalTo(25)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
    }
    
    override func configureView() {
        isDoneButton.imageView?.tintColor = .darkGray
        
        todoTitleLabel.font = .boldSystemFont(ofSize: 18)
        memoLabel.font = .systemFont(ofSize: 15)
        dateLabel.font = .systemFont(ofSize: 15)
        hashtagLabel.font = .systemFont(ofSize: 15)
        hashtagLabel.textColor = .systemOrange
        
        isDoneButton.addTarget(self, action: #selector(isDoneButtonClicked), for: .touchUpInside)
    }
    
    func configureTableViewCellUI(data: ToDo) {
        todo = data
        todoTitleLabel.attributedText = setToDoTitle(data: data)
        memoLabel.text = data.memo
        dateLabel.text = DateFormatter.customDateFormatter(date: data.deadline)
        if let hashtag = data.hashTag {
            hashtagLabel.text = "#" + hashtag
        } else {
            hashtagLabel.text = nil
        }
        setFlagedImage(isFlaged: data.isFlaged)
        isDone = data.isDone
        setIsDoneImage(isDone: isDone)
    }
    
    @objc private func isDoneButtonClicked() {
        isDone = isDoneClosure?(isDone) ?? false
        setIsDoneImage(isDone: isDone)
    }
    
    func setIsDoneImage(isDone: Bool) {
        let image = isDone ? UIImage(systemName: "circlebadge.fill")?.applyingSymbolConfiguration(.init(hierarchicalColor: .white)) : UIImage(systemName: "circlebadge")
        
        isDoneButton.setImage(image, for: .normal)
    }
    
    private func setFlagedImage(isFlaged: Bool) {
        let flagImage = isFlaged ? "flag.fill" : ""
        flagImageView.isHidden = !isFlaged
        flagImageView.tintColor = .systemOrange
        flagImageView.image = UIImage(systemName: flagImage)
    }
    
    private func setToDoTitle(data: ToDo) -> NSMutableAttributedString {
        var valueStr: String
        
        switch data.importantValue {
        case 0:
            valueStr = "!"
        case 1:
            valueStr = "!!"
        case 2:
            valueStr = "!!!"
        default:
            valueStr = ""
        }
        
        let fullText = "\(valueStr) \(data.title)"
        let range = (fullText as NSString).range(of: "\(valueStr)")
        let attribtuedString = NSMutableAttributedString(string: fullText)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        
        return attribtuedString
    }
}
