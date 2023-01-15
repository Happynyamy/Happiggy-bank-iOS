//
//  UILabel+Color.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UILabel {

    /// 텍스트 일부의 색깔 변경
    /// - Parameters:
    ///   - color: 바꿀 색상을 나타내는 UIColor
    ///   - target: 색상을 바꿀 문자열
    func color(target: String, color: UIColor? = AssetColor.mainYellow) {
        guard let fullText = self.text,
              !fullText.isEmpty,
              let color = color
        else { return }
        
        var attributedString = fullText.nsMutableAttributedStringify()
        if let attributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        }

        let range = attributedString.mutableString.range(of: target)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        self.attributedText = attributedString
    }
}
