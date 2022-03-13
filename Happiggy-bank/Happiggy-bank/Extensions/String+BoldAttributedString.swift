//
//  String+BoldAttributedString.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

extension String {
    
    /// 문자열에서 targetString 부분만  fontSize 크기로 볼드 처리해서 NSMutableAttributedString 의 형태로 리턴
    func bold(targetString: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let boldFont = UIFont.boldSystemFont(ofSize: fontSize)
        let range = (self as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.font, value: boldFont, range: range)
        
        return attributedString
    }
}
