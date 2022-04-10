//
//  UIAlertAction+ConfirmAndCancel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/10.
//

import UIKit

extension UIAlertAction {
    
    // MARK: - Properties
    
    private enum Title {
        static let confirm = "확인"
        static let cancel = "취소"
    }
    
    
    // MARK: - Functions
    
    /// 확인 버튼 액션
    static func confirmAction(
        title: String? = Title.confirm,
        style: Style = .default,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        UIAlertAction(title: title, style: style, handler: handler)
    }
    
    /// 취소 버튼 액션
    static func cancelAction(
        title: String? = Title.cancel,
        style: Style = .cancel,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        UIAlertAction(title: title, style: style, handler: handler)
    }
}
