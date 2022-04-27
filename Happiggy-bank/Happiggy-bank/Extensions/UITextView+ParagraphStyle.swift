//
//  UITextView+ParagraphStyle.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/19.
//

import UIKit
import CoreData

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
        
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineSpacing = lineSpacing
        }
        
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .kern: characterSpacing
        ]
        
        self.typingAttributes = attributes
    }
}
