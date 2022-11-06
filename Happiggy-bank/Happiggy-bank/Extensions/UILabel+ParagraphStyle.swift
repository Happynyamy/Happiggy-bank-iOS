//
//  UILabel+ParagraphStyle.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/20.
//

import UIKit

extension UILabel {
    
    /// 자간, 행간, 폰트 설정 메서드
    func configureParagraphStyle(
        lineSpacing: CGFloat? = ParagraphStyle.lineSpacing,
        characterSpacing: CGFloat? = ParagraphStyle.characterSpacing,
        font: UIFont? = nil
    ) {
        var mutableAttributedString = self.attributedText?.mutableCopy()
                                        as? NSMutableAttributedString
        if mutableAttributedString == nil {
            mutableAttributedString = self.text?.nsMutableAttributedStringify()
        }
        
        guard let mutableAttributedString = mutableAttributedString
        else { return }
        
        let lineSpacing = (lineSpacing == nil) ? .zero : lineSpacing!
        let characterSpacing = (characterSpacing == nil) ? .zero : characterSpacing!
        let font: UIFont = (font == nil) ? (self.font ?? UIFont()) : font!
        
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineSpacing = lineSpacing
        }
        
        mutableAttributedString.addAttributes(
            [
                .paragraphStyle: paragraphStyle,
                .font: font,
                .kern: characterSpacing
            ],
            range: NSRange(location: .zero, length: mutableAttributedString.length)
        )
        
        self.attributedText = mutableAttributedString
    }
}
