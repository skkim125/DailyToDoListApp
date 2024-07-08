//
//  UITableView+Extension.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import UIKit

extension UITableView {
    static func reloadView(cv: UICollectionView, tv: UITableView) {
        cv.reloadData()
        tv.reloadData()
    }
}
