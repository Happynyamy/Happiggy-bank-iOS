//
//  String+NSMutableAttributedStringify.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/18.
//

import Foundation

extension String {
    
    /// NSMutableAttributedString 으로 변환하기 위한 syntatic sugar
    func nsMutableAttributedStringify() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }
}
