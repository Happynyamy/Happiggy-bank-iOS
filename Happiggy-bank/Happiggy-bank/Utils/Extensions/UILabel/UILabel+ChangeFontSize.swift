//
//  UILabel+ChangeFontSize.swift
//  Happiggy-bank
//
//  Created by sun on 2022/11/06.
//

import UIKit

extension UILabel {

    /// 인자로 받은 사이즈로 폰트 사이즈를 변경 
    func changeFontSize(to size: CGFloat) {
        self.font = self.font.withSize(size)
    }
}
