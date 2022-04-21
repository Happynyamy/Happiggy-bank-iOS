//
//  NSMutableAttributedString+ColorBold.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/18.
//

import UIKit

extension NSMutableAttributedString {
    
    /// targetString 이 비어있는 경우 자기 자신 리턴
    private func returnSelfIfTargetIsEmpty(targetString: String) -> String {
        targetString.isEmpty ? self.string : targetString
    }
    
    /// 문자열에서 targetString 부분만  fontSize 크기로 볼드 처리해서 NSMutableAttributedString 의 형태로 리턴
    /// targetString 을 빈 문자열로 설정하면 전체를 변경
    @discardableResult
    func bold(targetString: String = .empty, fontSize: CGFloat) -> NSMutableAttributedString {
        let targetString = returnSelfIfTargetIsEmpty(targetString: targetString)
        let boldFont = UIFont.boldSystemFont(ofSize: fontSize)
        let range = self.mutableString.range(of: targetString)
        self.addAttribute(.font, value: boldFont, range: range)
        
        return self
    }
    
    /// 문자열에서 targetString 부분만 색깔을 변경해서 NSMutableAttributedString 의 형태로 리턴
    /// targetString 을 빈 문자열로 설정하면 전체를 변경
    @discardableResult
    func color(targetString: String = .empty, color: UIColor) -> NSMutableAttributedString {
        let targetString = returnSelfIfTargetIsEmpty(targetString: targetString)
        let range = self.mutableString.range(of: targetString)
        self.addAttribute(.foregroundColor, value: color, range: range)
        
        return self
    }
}
