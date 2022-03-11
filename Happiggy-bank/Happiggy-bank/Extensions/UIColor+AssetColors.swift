//
//  UIColor+AssetColors.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

extension UIColor {
    
    /// 애셋에 추가한 쪽지 하이라이트 색상을 반환하는 메서드
    static func highlight(color: String) -> UIColor {
        UIColor(named: AssetColor.noteHighlight.rawValue + color) ?? .systemGray3
    }
    
    /// 애셋에 추가한 쪽지 색상을 반환하는 메서드
    static func note(color: String) -> UIColor {
        UIColor(named: AssetColor.note.rawValue + color) ?? .white
    }
}
