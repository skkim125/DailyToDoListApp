//
//  MainViewButton.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/8/24.
//

import UIKit

class MainViewButton: UIButton {
    
    init(title: String, image: String?, type: UIButton.ButtonType, fontSize: CGFloat) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.plain()
        
        var titleStr = AttributedString(title)
        titleStr.font = .boldSystemFont(ofSize: fontSize)
        
        configuration.attributedTitle = titleStr
        configuration.image = UIImage(systemName: image ?? "")?.applyingSymbolConfiguration(.init(pointSize: 20, weight: .bold))
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.baseForegroundColor = .systemBlue
        
        self.configuration = configuration
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
