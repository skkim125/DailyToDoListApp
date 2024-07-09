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
        addSubview(folderButton)
    }
    
    override func configureLayout() {
        folderButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
    }
    
    func configureView(folder: Folder) {
        folderButton.todoButtonLabel.text = folder.title
        folderButton.todoDataLabel.text = "\(folder.todo.count)"
        folderButton.backgroundColor = UIColor(hex: folder.color)
        folderButton.addTarget(self, action: #selector(folderButtonClicked), for: .touchUpInside)
    }
    
    @objc private func folderButtonClicked() {
        moveData?()
    }
}
