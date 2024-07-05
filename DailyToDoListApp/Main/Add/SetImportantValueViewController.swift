//
//  SetIsImportantViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit

final class SetImportantValueViewController: BaseViewController {
    private let segment = UISegmentedControl()
    var importantValue = 1
    var beforeVC: AddToDoViewController?
    
    override func configureHierarchy() {
        view.addSubview(segment)
        print(self.importantValue)
    }
    
    override func configureLayout() {
        segment.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(35)
        }
    }
    
    override func configureView() {
        let lowValue = UIAction(title: ImportantVlue.low.rawValue) { _ in
            self.importantValue = ImportantVlue.low.value
            print(self.importantValue)
        }
        
        let midValue = UIAction(title: ImportantVlue.mid.rawValue) { _ in
            self.importantValue = ImportantVlue.mid.value
            print(self.importantValue)
        }
        
        let highValue = UIAction(title: ImportantVlue.high.rawValue) { _ in
            self.importantValue = ImportantVlue.high.value
            print(self.importantValue)
        }
        
        segment.insertSegment(action: lowValue, at: 0, animated: true)
        segment.insertSegment(action: midValue, at: 1, animated: true)
        segment.insertSegment(action: highValue, at: 2, animated: true)
        
        segment.selectedSegmentIndex = importantValue
        segment.selectedSegmentTintColor = .systemBlue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = beforeVC {
            vc.sendImportantValue(importantValue: self.importantValue)
        }
    }
}
