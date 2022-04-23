//
//  UIView+AllFontUsingSubviews.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UIView {
    
    /// 하위 뷰들의 하위 뷰를 포함한 모든 폰트를 사용하는 하위 뷰들의 배열
    var allFontUsingSubviews: [UIView] {
        var subviews = self.fontUsingSubviews
        self.subviews.forEach { subviews += $0.allFontUsingSubviews }
        
        return subviews
    }
    
    /// 폰트를 사용하는 하위뷰들의 배열
    private var fontUsingSubviews: [UIView] {
        self.subviews.filter {
            $0 as? UILabel != nil || $0 as? UITextField != nil || $0 as? UITextView != nil
        }
    }
}
