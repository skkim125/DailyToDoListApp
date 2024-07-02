//
//  IdProtocol.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/2/24.
//

import UIKit

protocol SetIdentifier {
    static var id: String { get }
}

extension UIView: SetIdentifier {
    static var id: String {
        String(describing: self)
    }
}
