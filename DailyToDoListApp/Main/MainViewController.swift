//
//  MainViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class MainViewController: BaseViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.configureCollectionViewLayout())
    
    private let addTodoButton = UIButton(type: .custom)
    
    private let realm = try! Realm()
    private let toDoRepository = ToDoRepository()
    private lazy var list: Results<ToDo> = toDoRepository.loadToDoList()
    
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
    }
    
    override func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionView.self, forCellWithReuseIdentifier: MainCollectionView.id)
        collectionView.backgroundColor = .black
        
        var configuration = UIButton.Configuration.plain()
        
        var title = AttributedString("새로운 할 일")
        title.font = .boldSystemFont(ofSize: 20)
        
        configuration.attributedTitle = title
        configuration.image = UIImage(systemName: "plus.circle.fill")!.applyingSymbolConfiguration(.init(pointSize: 20, weight: .bold))
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.baseForegroundColor = .systemBlue
        
        addTodoButton.configuration = configuration
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
    }
    
    @objc private func addTodoButtonClicked() {
        let vc = AddToDoViewController()
        vc.sendData = {
            self.collectionView.reloadData()
        }
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(realm.configuration.fileURL)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SortType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionView.id, for: indexPath) as? MainCollectionView {
            let data = SortType.allCases[indexPath.row]
            
            cell.configureTableViewCellUI(data: data, count: loadList(data: data, list: list).count)
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = SortType.allCases[indexPath.row]
        let vc = ToDoListViewController()
        
        vc.configureSetList(list: loadList(data: data, list: list))
        vc.configureNavigationBar(sortType: data)
        vc.beforeVC = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadList(data: SortType, list: Results<ToDo>) -> Results<ToDo>! {
        
        switch data {
        case .all:
            return list
        case .today:
            let filter = list.where { $0.deadline >= Calendar.current.startOfDay(for: Date()) && $0.deadline <= Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: Date())) }.sorted(byKeyPath: "date", ascending: true)
            return filter
        case .willDo:
            let filter = list.where { $0.deadline > Date(timeInterval: 86400, since: Calendar.current.startOfDay(for: Date())) }.sorted(byKeyPath: "date", ascending: true)
            return filter
        case .isFlaged:
            return list.where { $0.isFlaged }.sorted(byKeyPath: "date", ascending: true)
        case .isDone:
            return list.where { $0.isDone }.sorted(byKeyPath: "date", ascending: true)
        }
    }
}
