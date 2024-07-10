//
//  AddToDoViewModel.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/10/24.
//

import Foundation

class AddToDoViewModel {
    
    var inputTextViewText: Observable<String?> = Observable("")
    var inputDate: Observable<Date> = Observable(Date())
    
    var outputhiddenLabel: Observable<Bool> = Observable(false)
    var outputDateLabelText: Observable<String?> = Observable("")
    var outputImportantValueText: Observable<String?> = Observable("")
    var outputHashtagText: Observable<String?> = Observable("")
    
    init() {
        inputTextViewText.bind { text in
            self.placeholderHidden(text: text)
        }
        
        inputDate.bind { date in
            self.convertDate(date: date)
        }
    }
    
    private func placeholderHidden(text: String?) {
        if let text = text, !text.isEmpty {
            self.outputhiddenLabel.value = true
        } else {
            self.outputhiddenLabel.value = false
        }
    }
    
    private func convertDate(date: Date) {
        outputDateLabelText.value = DateFormatter.customDateFormatter(date: date)
    }
}
