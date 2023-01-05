//
//  UIViewController+ObserveCustomFontChange.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UIViewController {
    
    /// 커스텀 폰트 설정이 변화하면 이를 옵저브하고, 변경사항을 적용
    /// 셀렉터를 별도로 설정하지 않으면 (폰트를 사용하는) 모든 하위 뷰의 폰트를 업데이트
    func observeCustomFontChange(selector: Selector? = nil) {
        let selector = (selector == nil) ? #selector(fontDidChange(_:)) : selector!
        self.observe(
            selector: selector,
            name: .customFontDidChange
        )
    }
    
    /// 폰트를 사용하는 모든 하위뷰의 폰트를 업데이트
    func updateAllFontUsingViews(_ customFont: CustomFont) {
        
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
    
    /// 커스텀 폰트 변화 시 변경 사항을 필요한 하위 뷰에 적용
    @objc private func fontDidChange(_ notification: Notification) {
        
        guard let customFont = notification.object as? CustomFont
        else { return }
        
        self.updateAllFontUsingViews(customFont)
    }
}
