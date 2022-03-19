//
//  UITextView+ParagraphStyle.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/19.
//

import UIKit

extension UITextView {
    
    /// 자간, 행간, 폰트 설정 메서드
    func configureParagraphStyle(
        lineSpacing: CGFloat? = nil,
        characterSpacing: CGFloat? = nil,
        font: UIFont? = nil
    ) {
        let lineSpacing = (lineSpacing == nil) ? .zero : lineSpacing!
        let characterSpacing = (characterSpacing == nil) ? .zero : characterSpacing!
        let font: UIFont = (font == nil) ? (self.font ?? UIFont()) : font!
        
        let attributedString = self.text.nsMutableAttributedStringify()
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineSpacing = lineSpacing
        }
        
        attributedString.addAttributes(
            [
                .paragraphStyle: paragraphStyle,
                .font: font,
                .kern: characterSpacing
            ],
            range: NSRange(location: .zero, length: attributedString.length)
        )

        self.attributedText = attributedString
    }
}
