//
//  MainCollectionView.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit

final class MainCollectionView: BaseCollectionViewCell {
    
    private let imageView = UIImageView()
    private let collectionTitleLabel = UILabel()
    private let listCountLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(collectionTitleLabel)
        contentView.addSubview(listCountLabel)
    }
    
    override  func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.size.equalTo(40)
        }
        
        collectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.leading)
            make.height.equalTo(20)
        }
        
        listCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(30)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 12
        
        imageView.contentMode = .scaleAspectFit
        
        collectionTitleLabel.textColor = .lightGray
        collectionTitleLabel.font = .systemFont(ofSize: 18)
        
        listCountLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    func configureTableViewCellUI(data: SortType, count: Int) {
        imageView.image = data.image
        imageView.tintColor = data.imageTintColor
        collectionTitleLabel.text = data.rawValue
        listCountLabel.text = "\(count)"
    }
    
}
