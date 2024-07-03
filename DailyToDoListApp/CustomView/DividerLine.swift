//
//  DividerLine.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import UIKit


class DividerLine: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
