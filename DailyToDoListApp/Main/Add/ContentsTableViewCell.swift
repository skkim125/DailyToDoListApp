//
//  ContentsTableViewCell.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit

class ContentsTableViewCell: BaseTableViewCell {
    let contentsTableView = UITableView()
    
    override func configureHierarchy() {
        contentView.addSubview(contentsTableView)
    }
    
    override func configureLayout() {
        contentsTableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        contentsTableView.register(MemoTextViewTableViewCell.self, forCellReuseIdentifier: MemoTextViewTableViewCell.id)
        contentsTableView.register(TitleTFTableViewCell.self, forCellReuseIdentifier: TitleTFTableViewCell.id)
        contentsTableView.isScrollEnabled = false
        contentsTableView.layer.cornerRadius = 10
    }
}

extension ContentsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTFTableViewCell.id, for: indexPath) as! TitleTFTableViewCell
            cell.configureContentViewCell()
            print("title", indexPath.row)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MemoTextViewTableViewCell.id, for: indexPath) as! MemoTextViewTableViewCell
            
            cell.configureMemoTextView()
            print("memo", indexPath.row)
            
            return cell
        }
    }
}
