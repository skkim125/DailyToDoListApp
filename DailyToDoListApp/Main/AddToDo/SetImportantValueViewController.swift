//
//  SetIsImportantViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit

final class SetImportantValueViewController: BaseViewController {
    private let segment = UISegmentedControl()
    var beforeVC: AddToDoViewController?
    var viewModel: ToDoViewModel?
    
    override func configureHierarchy() {
        view.addSubview(segment)
    }
    
    override func configureLayout() {
        segment.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(35)
        }
    }
    
    override func configureView() {
        if let vm = viewModel {
            let lowValue = UIAction(title: ImportantValue.low.rawValue) { _ in
                vm.inputImportantValue.value = ImportantValue.low.value
            }
            
            let midValue = UIAction(title: ImportantValue.mid.rawValue) { _ in
                vm.inputImportantValue.value = ImportantValue.mid.value
            }
            
            let highValue = UIAction(title: ImportantValue.high.rawValue) { _ in
                vm.inputImportantValue.value = ImportantValue.high.value
            }
            
            segment.insertSegment(action: lowValue, at: 0, animated: true)
            segment.insertSegment(action: midValue, at: 1, animated: true)
            segment.insertSegment(action: highValue, at: 2, animated: true)
            
            segment.selectedSegmentIndex = vm.inputImportantValue.value ?? 1
            segment.selectedSegmentTintColor = .systemBlue
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = beforeVC {
            vc.sendImportantValue()
        }
    }
}
