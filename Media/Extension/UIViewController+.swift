//
//  UIViewController+.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

extension UIViewController {
    
    func presentActionSheet(
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
    
    func presentErrorAlert(
        title: String,
        message: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func presentAlert(
        title: String,
        message: String,
        actionTitle: String,
        completionHandler: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: actionTitle, style: .default, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}
