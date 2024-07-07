//
//  CalendarViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/6/24.
//

import UIKit
import FSCalendar
import SnapKit
import RealmSwift

class CalendarViewController: BaseViewController {
    private let calendarBGView = UIView()
    private let calendarView = CustomCalendar()
    private let nextButton = UIButton()
    private let previousButton = UIButton()
    private let calendarStyleButton = UIButton()
    private let divider = DividerLine()
    private let toDoListTableView = UITableView()
    
    private let realm = try! Realm()
    
    private lazy var todoList: Results<ToDo>! = realm.objects(ToDo.self)
    private var isStyleChanged: Bool = true
    var beforeVC: MainViewController?
    
    override func configureNavigationBar() {
        navigationItem.title = "캘린더로 보기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    override func configureHierarchy() {
        view.addSubview(calendarBGView)
        calendarBGView.addSubview(calendarView)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        view.addSubview(calendarStyleButton)
        view.addSubview(divider)
        view.addSubview(toDoListTableView)
    }
    
    override func configureLayout() {
        calendarBGView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(320)
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
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(calendarBGView.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(calendarBGView)
        }
        
        toDoListTableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
        toDoListTableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.id)
        toDoListTableView.rowHeight = 100
        
        calendarBGView.clipsToBounds = true
        calendarBGView.layer.cornerRadius = 12
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
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
        
        let calendar = Calendar.current
        
        calendarView.currentPage = calendar.date(byAdding: dateComponents, to: calendarView.currentPage) ?? Date()
        calendarView.setCurrentPage(calendarView.currentPage, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let date = calendarView.today {
            updateList(date: date)
        }
    }
    
    private func updateList(date: Date) {
        let krDate = Date.krDate(date: date)
        todoList = realm.objects(ToDo.self).where { $0.deadline >= Calendar.current.startOfDay(for: krDate) && $0.deadline <= Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: krDate)) }
        
        toDoListTableView.reloadData()
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.id, for: indexPath) as? ToDoListTableViewCell else { return UITableViewCell()}
        let data = todoList[indexPath.row]
        
        cell.configureTableViewCellUI(data: todoList[indexPath.row])
        cell.isDoneClosure = { before in
            var after = before
            after.toggle()
            
            let realm = try! Realm()
            print(data.id)
            do {
                try realm.write {
                    realm.create(ToDo.self,
                                 value: ["id": data.id ,
                                        "isDone": after],
                                 update: .modified)
                }
            } catch {
                print("Error")
            }
            
            tableView.reloadData()
            if let vc = self.beforeVC {
                vc.collectionView.reloadData()
            }
            return after
        }
        cell.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 0)
        cell.selectionStyle = .none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let data = todoList[indexPath.row]
        var flaged = data.isFlaged
        flaged.toggle()
        
        let edit = UIContextualAction(style: .normal, title: data.isFlaged ? "깃발 해제" : "깃발 표시") { (action, view, success: @escaping (Bool) -> Void) in
            
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.create(ToDo.self,
                                 value: ["id": data.id ,
                                        "isFlaged": flaged],
                                 update: .modified)
                }
            } catch {
                print("Error")
            }
            
            if let vc = self.beforeVC {
                vc.collectionView.reloadData()
                tableView.reloadData()
            }
            success(true)
        }
        
        edit.backgroundColor = .systemOrange
        edit.image = UIImage(systemName: data.isFlaged ? "flag.slash.fill" : "flag.fill")
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, success: @escaping (Bool) -> Void) in
            success(true)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions:[delete, edit])
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        updateList(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let data = realm.objects(ToDo.self)
        let krDate = Date.krDate(date: date)
        if data.contains(where: { $0.deadline >= Calendar.current.startOfDay(for: krDate) && $0.deadline <= Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: krDate)) }) {
            print("Yes")
            return 1
        } else {
            print("No")
            return 0
        }
    }
}
