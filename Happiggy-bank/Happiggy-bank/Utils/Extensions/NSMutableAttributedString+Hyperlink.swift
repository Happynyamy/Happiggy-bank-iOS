//
//  NSMutableAttributedString+Hyperlink.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import Foundation

extension NSMutableAttributedString {
    
    /// 지정한 문자열에 하이퍼링크 추가
    @discardableResult
    func addHyperLinks(hyperlinks: [String: String]) -> NSMutableAttributedString {
        for (hyperlink, urlString) in hyperlinks {
            let linkRange = self.mutableString.range(of: hyperlink)
            self.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        }
        
        return self
    }
}
