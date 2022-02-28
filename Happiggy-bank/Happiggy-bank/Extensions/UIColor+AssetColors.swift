//
//  UIColor+AssetColors.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

extension UIColor {
    
    /// 흰색 쪽지 색상
    static let noteWhite = UIColor(named: "noteWhite") ?? .white
    
    /// 분홍 쪽지 색상
    static let notePink = UIColor(named: "notePink") ?? .systemPink
    
    /// 보라 쪽지 색상
    static let notePurple = UIColor(named: "notePurple") ?? .systemPurple
    
    /// 연두 쪽지 색상
    static let noteGreen = UIColor(named: "noteGreen") ?? .systemGreen
    
    /// 노랑 쪽지 색상
    static let noteYellow = UIColor(named: "noteYellow") ?? .systemYellow
    
    /// 쪽지 디폴트 색상
    static let noteDefault = noteWhite
    
    /// 흰색 쪽지 하이라이트 색상
    static let noteWhiteHighlight = UIColor(named: "noteWhiteHighlight") ?? .black
    
    /// 분홍 쪽지 하이라이트 색상
    static let notePinkHighlight = UIColor(named: "notePinkHighlight") ?? .black
    
    /// 보라 쪽지 하이라이트 색상
    static let notePurpleHighlight = UIColor(named: "notePurpleHighlight") ?? .black
    
    /// 연두 쪽지 하이라이트 색상
    static let noteGreenHighlight = UIColor(named: "noteGreenHighlight") ?? .black
    
    /// 노랑 쪽지 하이라이트 색상
    static let noteYellowHighlight = UIColor(named: "noteYellowHighlight") ?? .black
    
    /// 쪽지 색상에 따른 하이라이트 색상을 담고 있는 딕셔너리
    static var highlightColors: [UIColor: UIColor] = [
        .noteWhite: .noteWhiteHighlight,
        .notePink: .notePinkHighlight,
        .notePurple: .notePurpleHighlight,
        .noteGreen: .noteGreenHighlight,
        .noteYellow: .noteYellowHighlight
    ]
    
    /// 쪽지 색상에 따른 하이라이트 색상을 리턴하는 메서드
    static func highlightColor(for color: UIColor) -> UIColor {
        highlightColors[color] ?? .black
    }
}
