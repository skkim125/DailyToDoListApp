//
//  CalendarViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/6/24.
//

import UIKit
import FSCalendar
import SnapKit

class CalendarViewController: BaseViewController {
    let calendarBGView = UIView()
    let calendarView = CustomCalendar()
    let nextButton = UIButton()
    let previousButton = UIButton()
    let calendarStyleButton = UIButton()
    private var isStyleChanged: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(calendarBGView)
        calendarBGView.addSubview(calendarView)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        view.addSubview(calendarStyleButton)
        
        calendarBGView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(300)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalTo(calendarBGView)
        }
        
        previousButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).offset(12)
            make.leading.equalTo(calendarView.snp.leading).offset(70)
            make.size.equalTo(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).offset(12)
            make.trailing.equalTo(calendarView.snp.trailing).inset(70)
            make.size.equalTo(20)
        }
        
        calendarStyleButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).inset(12)
            make.trailing.equalTo(calendarView.snp.trailing).inset(20)
            make.size.equalTo(20)
        }
        
        calendarBGView.clipsToBounds = true
        calendarBGView.layer.cornerRadius = 12
        
        nextButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        nextButton.tintColor = .white
        
        previousButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        previousButton.tintColor = .white
        previousButton.addTarget(self, action: #selector(previousButtonClicked), for: .touchUpInside)
        
        calendarStyleButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        calendarStyleButton.tintColor = .lightGray
        calendarStyleButton.addTarget(self, action: #selector(calendarStyleChange), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        moveCurrentPage(moveUp: true)
    }
    
    @objc func previousButtonClicked() {
        moveCurrentPage(moveUp: false)
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        var dateComponents = DateComponents()
        if isStyleChanged {
            dateComponents.month = moveUp ? 1 : -1
        } else {
            dateComponents.weekOfMonth = moveUp ? 1 : -1
        }
        
        calendarView.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.calendarView.currentPage) ?? Date()
            self.calendarView.setCurrentPage(self.calendarView.currentPage, animated: true)
        }
    
    override func configureNavigationBar() {
        navigationItem.title = "캘린더로 보기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func calendarStyleChange() {
        isStyleChanged.toggle()
        
        calendarStyleButton.setImage(UIImage(systemName: isStyleChanged ? "chevron.up" : "chevron.down"), for: .normal)
        
        calendarView.scope = isStyleChanged ? .month : .week
    
        calendarBGView.snp.updateConstraints { make in
            make.height.equalTo(isStyleChanged ? 300 : 120)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonClicked() {
        
        dismiss(animated: true)
    }
}
