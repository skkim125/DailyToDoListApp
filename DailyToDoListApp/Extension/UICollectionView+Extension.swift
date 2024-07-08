//
//  UICollectionView+Extension.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import UIKit

extension UICollectionViewLayout {
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 20
        let sectionSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (sectionSpacing*2 + cellSpacing)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = sectionSpacing
        layout.itemSize = CGSize(width: width/2, height: width/3.8)
        layout.sectionInset = .init(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
}
