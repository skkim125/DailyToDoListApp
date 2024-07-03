//
//  SetToDoContentViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/3/24.
//

import UIKit
import SnapKit

class SetToDoContentViewController: BaseViewController {
    var content: TodoContents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = content else { return }
        
    }
}
