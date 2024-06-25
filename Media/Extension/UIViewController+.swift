//
//  UIViewController+.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

extension UIViewController {
    
    func showActionSheet(
        title1: String,
        title2: String,
        firstAction: @escaping (UIAlertAction) -> Void,
        secondAction: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let day = UIAlertAction(title: TimeWindow.day.rawValue, style: .default, handler: firstAction)
        let week = UIAlertAction(title: TimeWindow.week.rawValue, style: .default, handler: secondAction)
        alert.addAction(day)
        alert.addAction(week)
        present(alert, animated: true)
    }
    
}
