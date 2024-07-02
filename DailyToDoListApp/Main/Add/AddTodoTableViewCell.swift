//
//  AddTodoTableViewCell.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit

final class AddTodoTableViewCell: BaseTableViewCell {
    let todoContentsButton = UIButton()
    let todoButtonLabel = UILabel()
    let goNextViewImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(todoContentsButton)
        todoContentsButton.addSubview(goNextViewImageView)
        todoContentsButton.addSubview(todoButtonLabel)
    }
    
    override func configureLayout() {
        todoContentsButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        todoButtonLabel.snp.makeConstraints { make in
            make.leading.equalTo(todoContentsButton.snp.leading).offset(10)
            make.centerY.equalTo(todoContentsButton)
        }
        
        goNextViewImageView.snp.makeConstraints { make in
            make.trailing.equalTo(todoContentsButton.snp.trailing).inset(15)
            make.centerY.equalTo(todoContentsButton)
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        var configuration = UIButton.Configuration.bordered()
        configuration.baseBackgroundColor = .systemGray5
        configuration.titleAlignment = .leading
        
        todoContentsButton.configuration = configuration
        
        todoContentsButton.tintColor = .white
        todoContentsButton.addTarget(self, action: #selector(todoClicked), for: .touchUpInside)
        todoContentsButton.clipsToBounds = true
        todoContentsButton.layer.cornerRadius = 8
        
        
        todoButtonLabel.textColor = .white
        
        goNextViewImageView.image = UIImage(systemName: "chevron.forward")
        goNextViewImageView.tintColor = .lightGray
        goNextViewImageView.contentMode = .scaleAspectFit
    }
    
    func configureButtonUI(text: String) {
        todoButtonLabel.text = text
    }
    
    @objc func todoClicked() {
        print(#function)
    }
    
}
