//
//  ToDoElementButton.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import UIKit
import SnapKit

class MenuButtonUI: UIButton {
    let todoButtonLabel = UILabel()
    let goNextViewImageView = UIImageView()
    let todoDataLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureButton()
        configureHierarchy()
        configureLayout()
        configureSubView()
    }
    
    private func configureButton() {
        var configuration = UIButton.Configuration.bordered()
        configuration.baseBackgroundColor = .systemGray5
        configuration.titleAlignment = .leading
        
        self.configuration = configuration
        tintColor = .white
        clipsToBounds = true
        layer.cornerRadius = 12
    }
    
    private func configureHierarchy() {
        addSubview(todoButtonLabel)
        addSubview(goNextViewImageView)
        addSubview(todoDataLabel)
    }
    
    private func configureLayout() {
        todoButtonLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.centerY.equalTo(self)
        }
        
        goNextViewImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).inset(10)
            make.centerY.equalTo(self)
            make.size.equalTo(20)
        }
        
        todoDataLabel.snp.makeConstraints { make in
            make.trailing.equalTo(goNextViewImageView.snp.leading).inset(-5)
            make.leading.equalTo(self.snp.centerX)
            make.centerY.equalTo(goNextViewImageView.snp.centerY)
            make.height.equalTo(25)
        }
    }
    
    func getButtonTag(element: TodoContents) {
        tag = element.buttonTag
    }
    
    private func configureSubView() {
        todoButtonLabel.textColor = .white.withAlphaComponent(0.7)
        todoButtonLabel.font = .systemFont(ofSize: 15)
        
        todoDataLabel.textColor = .lightGray
        todoDataLabel.textAlignment = .right
        
        goNextViewImageView.image = UIImage(systemName: "chevron.forward")
        goNextViewImageView.tintColor = .lightGray
        goNextViewImageView.contentMode = .scaleAspectFit
    }
    
    func configureButtonText(title: String) {
        todoButtonLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func buttonAddTarget(_ button: UIButton, _ target: Any?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
