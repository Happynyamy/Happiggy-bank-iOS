//
//  UIViewController+ObserveCustomFontChange.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UIViewController {
    
    /// 커스텀 폰트 설정이 변화하면 이를 옵저브하고, 변경사항을 적용
    func observeCustomFontChange() {
        self.observe(
            selector: #selector(customFontDidChange(_:)),
            name: .customFontDidChange
        )
    }
    
    /// 커스텀 폰트 변화 시 변경 사항을 필요한 하위 뷰에 적용
    @objc private func customFontDidChange(_ notification: Notification) {
        
        guard let customFont = notification.object as? CustomFont
        else { return }
        
        self.view.allFontUsingSubviews.forEach {
            
            if let label = $0 as? UILabel {
                let name = (label.font.isBold) ? customFont.bold : customFont.regular
                label.font = UIFont(name: name, size: label.font.pointSize)
            }
            
            if let textField = $0 as? UITextField {
                let name = (textField.font?.isBold == true) ? customFont.bold : customFont.regular
                let size = textField.font?.pointSize ?? UIFont.systemFontSize
                textField.font = UIFont(name: name, size: size)
            }
            
            if let textView = $0 as? UITextView {
                let name = (textView.font?.isBold == true) ? customFont.bold : customFont.regular
                let size = textView.font?.pointSize ?? UIFont.systemFontSize
                textView.font = UIFont(name: name, size: size)
            }
        }
    }
}
