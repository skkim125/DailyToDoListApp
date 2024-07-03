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
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 20
        let sectionSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (sectionSpacing*2 + cellSpacing)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = sectionSpacing
        layout.itemSize = CGSize(width: width/2, height: width/3.6)
        layout.sectionInset = .init(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    private let addTodoButton = UIButton()
    
    private let realm = try! Realm()
    private var list: Results<Todo>!
    
    override func configureNavigationBar() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "오늘 할 일"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(sortButtonClicked))
    }
    
    @objc private func sortButtonClicked() {
//        navigationItem.rightBarButtonItem
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
        
        addTodoButton.setTitle("새로운 할 일", for: .normal)
        addTodoButton.setTitleColor(.systemBlue, for: .normal)
        addTodoButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        addTodoButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addTodoButton.imageView?.contentMode = .scaleAspectFit
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
        
        list = realm.objects(Todo.self)
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
            
            cell.configureTableViewCellUI(data: data, count: data.list.count)
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = SortType.allCases[indexPath.row]
        
        let vc = ToDoListViewController()
        
        vc.list = data.list
        vc.configureNavigationBar(sortType: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
