//
//  MainViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

final class MainViewController: BaseViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.configureCollectionViewLayout())
    private let addTodoButton = MainViewButton(title: "새로운 할 일", image: "plus.circle.fill", type: .system, fontSize: 20)
    private let addMyFolderButton = MainViewButton(title: "목록 추가", image: nil, type: .system, fontSize: 18)
    
    private let toDoRepository = ToDoRepository()
    private lazy var list: Results<ToDo> = toDoRepository.loadToDoList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoRepository.loadURL()
    }
    
    override func configureNavigationBar() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "오늘 할 일"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonClicked))
    }
    
    @objc func calendarButtonClicked() {
        let vc = CalendarViewController()
        vc.beforeVC = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .flipHorizontal
        
        present(nav, animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(addTodoButton)
        view.addSubview(addMyFolderButton)
    }
    
    override func configureLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(addTodoButton.snp.top)
        }
        
        addTodoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        addMyFolderButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionView.self, forCellWithReuseIdentifier: MainCollectionView.id)
        collectionView.backgroundColor = .black
        
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
        addMyFolderButton.addTarget(self, action: #selector(addMyFolderButtonClicked), for: .touchUpInside)
    }
    
    @objc private func addTodoButtonClicked() {
        let vc = AddToDoViewController()
        vc.sendData = {
            self.collectionView.reloadData()
            self.view.makeToast("할 일이 추가되었어요")
        }
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true)
    }
    
    @objc private func addMyFolderButtonClicked() {
        let vc = AddMyFolderViewController()
        vc.sendData = {
            self.collectionView.reloadData()
            self.view.makeToast("폴더가 추가되었어요")
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListSortType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionView.id, for: indexPath) as? MainCollectionView {
            let data = ListSortType.allCases[indexPath.row]
            
            cell.configureTableViewCellUI(data: data, count: loadList(data: data, list: list).count)
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = ListSortType.allCases[indexPath.row]
        let vc = ToDoListViewController()
        
        vc.configureSetList(list: loadList(data: data, list: list))
        vc.configureNavigationBar(sortType: data)
        vc.beforeVC = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadList(data: ListSortType, list: Results<ToDo>) -> Results<ToDo>! {
        
        switch data {
        case .all:
            return list
        case .today:
            let filter = list.where { $0.deadline >= Calendar.current.startOfDay(for: Date()) && $0.deadline <= Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: Date())) }.sorted(byKeyPath: SortType.defualt.updateValueType, ascending: true)
            return filter
        case .willDo:
            let filter = list.where { $0.deadline > Date(timeInterval: 86400, since: Calendar.current.startOfDay(for: Date())) }.sorted(byKeyPath: SortType.defualt.updateValueType, ascending: true)
            return filter
        case .isFlaged:
            return list.where { $0.isFlaged }.sorted(byKeyPath: SortType.defualt.updateValueType, ascending: true)
        case .isDone:
            return list.where { $0.isDone }.sorted(byKeyPath: SortType.defualt.updateValueType, ascending: true)
        }
    }
}
