//
//  CustomDatePicker.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit

class CustomDatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 8
        clipsToBounds = true
        
        preferredDatePickerStyle = .inline
        locale = Locale(identifier: "ko_KR")
        datePickerMode = .date
        minimumDate = Date()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
