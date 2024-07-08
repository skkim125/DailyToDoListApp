//
//  ColorButton.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import UIKit

class ColorButton: UIButton {
    var color = ""
    
    init(color: String, buttonType: UIButton.ButtonType) {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: "circle.fill"), for: .normal)
        tintColor = UIColor(hex: color, alpha: 1)
        self.color = color
        imageView?.contentMode = .scaleToFill
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
