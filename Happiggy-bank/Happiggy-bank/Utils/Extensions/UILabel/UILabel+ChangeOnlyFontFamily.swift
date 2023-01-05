//
//  UILabel+ChangeOnlyFontFamily.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UILabel {
    
    /// 폰트와 사이즈를 변경, 사이즈를 지정하지 않으면 현재 사이즈 그대로 사용
    func changeFont(to name: String, size: CGFloat? = nil) {
        let size = (size == nil) ? self.font.pointSize : size!
        self.font = UIFont(name: name, size: size)
    }
}
