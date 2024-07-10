//
//  AddToDoViewModel.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/10/24.
//

import Foundation

class ToDoViewModel {
    
    var inputTextFieldLabel: Observable<String?> = Observable("")
    var inputTextViewText: Observable<String?> = Observable("")
    var inputDate: Observable<Date?> = Observable(Date())
    var inputHashtagText: Observable<String?> = Observable("")
    var inputImportantValue: Observable<Int?> = Observable(1)
    
    var outputhiddenLabel: Observable<Bool> = Observable(false)
    var outputDateLabelText: Observable<String?> = Observable("")
    var outputImportantValueText: Observable<String?> = Observable("")
    var outputHashtagText: Observable<String?> = Observable("")
    
    init() {
        inputTextViewText.bind { text in
            self.placeholderHidden(text: text)
        }
        
        inputDate.bind { date in
            self.convertDate(date: date ?? Date())
        }
        
        inputHashtagText.bind { hashtag in
            if let ht = hashtag, !ht.trimmingCharacters(in: .whitespaces).isEmpty {
                self.outputHashtagText.value = "#" + ht
            }
        }
        
        inputImportantValue.bind { value in
            self.outputImportantValueText.value = ImportantValue.allCases[value ?? 1].rawValue
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
