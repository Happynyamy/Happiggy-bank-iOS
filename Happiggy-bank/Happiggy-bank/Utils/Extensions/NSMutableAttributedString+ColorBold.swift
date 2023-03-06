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

    /// 문자열 일부의 폰트를 변경
    /// - Parameters:
    ///   - font: 변경하려는 폰트
    ///   - targetString: 변경하려는 범위
    /// - Returns: 지정한 범위의 폰트가 변경된 문자열
    @discardableResult
    func font(_ font: UIFont, targetString: String = .empty) -> NSMutableAttributedString {
        let targetString = returnSelfIfTargetIsEmpty(targetString: targetString)
        let range = self.mutableString.range(of: targetString)
        self.addAttribute(.font, value: font, range: range)

        return self
    }

    /// 문자열 일부를 볼드 처리
    /// - Parameters:
    ///   - font: 설정하려는 볼드 폰트(기본값은 문자열의 기존 폰트)
    ///   - targetString: 볼드체로 변경하려는 문자열의 범위(기본값은 전체)
    /// - Returns: 문자열에서 targetString 부분만  fontSize 크기로 볼드 처리해서 NSMutableAttributedString 의 형태로 리턴
    @discardableResult
    func bold(
        font: UIFont? = nil,
        targetString: String = .empty
    ) -> NSMutableAttributedString {
        let targetString = returnSelfIfTargetIsEmpty(targetString: targetString)
        let range = self.mutableString.range(of: targetString)

        let currentFont = self.attribute(.font, at: range.lowerBound, effectiveRange: nil)
        let font = font ?? currentFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.addAttribute(.font, value: font, range: range)
        
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
