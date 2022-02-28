//
//  UIViewController+Popup.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/22.
//

import UIKit

extension UIViewController {
    
    /// 새로운 쪽지 추가 팝업을 띄움
    func showNewNotePopup() {
        let popupViewController = NewNotePopupViewController()
        present(popupViewController, animated: false, completion: nil)
    }
}
