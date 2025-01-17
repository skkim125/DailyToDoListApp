//
//  SetDeadLineVIewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/4/24.
//

import UIKit
import SnapKit

final class SetDeadLineViewController: BaseViewController {
    let datePicker = CustomDatePicker()
    let deadlineLabel = UILabel()
    
    var viewModel: ToDoViewModel?
    var beforeView: AddToDoViewController?
    
    func bindDate() {
        if let vm = viewModel {
            deadlineLabel.text = vm.outputDateLabelText.value
            datePicker.date = vm.inputDate.value ?? Date()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
        view.addSubview(deadlineLabel)
    }
    
    override func configureLayout() {
        deadlineLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(deadlineLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(datePicker.snp.width)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        beforeView?.sendDeadline()
    }
    
    override func configureView() {
        datePicker.backgroundColor = .systemGray6
        datePicker.addTarget(self, action: #selector(datePickerClicked), for: .valueChanged)
        
        deadlineLabel.text = "\(DateFormatter.customDateFormatter(date: Date()))"
        deadlineLabel.font = .boldSystemFont(ofSize: 20)
        deadlineLabel.textAlignment = .center
        
        bindDate()
    }
    
    @objc private func datePickerClicked(_ sender: UIDatePicker) {
        print(sender.date)
        
        if let vm = viewModel {
            vm.inputDate.value = sender.date
        }
        
        bindDate()
    }
}
