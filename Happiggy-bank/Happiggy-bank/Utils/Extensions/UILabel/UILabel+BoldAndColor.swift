//
//  UILabel+BoldAndColor.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UILabel {
    
    /// 라벨 볼드 처리
    func bold(target: String? = nil) {
        let key = UserDefaults.Key.font.rawValue
        guard let rawValue = UserDefaults.standard.value(forKey: key) as? Int,
              let font = CustomFont(rawValue: rawValue),
              let fullText = self.text,
              !fullText.isEmpty,
              let bold = UIFont(name: font.bold, size: self.font.pointSize)
        else { return }
        
    
        var attributedString = fullText.nsMutableAttributedStringify()
        if let attributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        }

        let target = (target == nil) ? fullText : target!
        let range = attributedString.mutableString.range(of: target)
        
        attributedString.addAttribute(.font, value: bold, range: range)
        self.attributedText = attributedString
    }
    
    /// 라벨 글자 색상 변경
    func color(_ color: UIColor? = AssetColor.mainYellow, target: String? = nil) {
        guard let fullText = self.text,
              !fullText.isEmpty,
              let color = color
        else { return }
        
        var attributedString = fullText.nsMutableAttributedStringify()
        if let attributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        }

        let target = (target == nil) ? fullText : target!
        let range = attributedString.mutableString.range(of: target)
        
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        self.attributedText = attributedString
    }
    
    /// 라벨 볼드처리 및 글자 색상 변경
    func boldAndColor(target: String? = nil, color: UIColor? = AssetColor.mainYellow) {
        self.color(color, target: target)
        self.bold(target: target)
    }
}
