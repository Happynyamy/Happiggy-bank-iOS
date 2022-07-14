//
//  UIAlertController+BasicFormat.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/10.
//

import UIKit

extension UIAlertController {
    
    /// 취소, 확인 버튼이 있는 알림 컨트롤러 생성
    static func basic(
        alertTitle: String? = nil,
        alertMessage: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        confirmAction: UIAlertAction? = nil,
        cancelAction: UIAlertAction? = nil
    ) -> UIAlertController {
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: preferredStyle
        )
        
        if let confirmAction = confirmAction {
            alert.addAction(confirmAction)
        }
        
        if let cancelAction = cancelAction {
            alert.addAction(cancelAction)
        }
        
        return alert
    }
}
