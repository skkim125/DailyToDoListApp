//
//  FolderTableViewCell.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/9/24.
//

import UIKit
import SnapKit

class FolderTableViewCell: BaseTableViewCell {
    let folderButton = MenuButtonUI()
    var mainVC: MainViewController?
    var moveData: (()->Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(folderButton)
    }
    
    override func configureLayout() {
        folderButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureButton(folder: Folder) {
        folderButton.configuration?.baseBackgroundColor = UIColor(hex: folder.color)
        folderButton.todoButtonLabel.text = folder.title
        folderButton.todoButtonLabel.font = .systemFont(ofSize: 16)
        folderButton.todoButtonLabel.textColor = .white
        folderButton.todoDataLabel.text = "\(folder.todo.count)"
        folderButton.goNextViewImageView.tintColor = .white
        folderButton.todoDataLabel.textColor = .white
        
        folderButton.addTarget(self, action: #selector(folderButtonClicked), for: .touchUpInside)
    }
    
    @objc private func folderButtonClicked() {
        moveData?()
    }
}
