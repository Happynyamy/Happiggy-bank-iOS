//
//  CustomFont.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/22.
//

import Foundation

/// 커스텀 폰트
enum CustomFont: Int, CaseIterable {
    
    /// 시스템 폰트
    case system
    
    /// 둘기마요
    case dovemayo
}

extension CustomFont {
    
    
    // MARK: - Properties
    
    /// 뷰에 표시할 이름
    static var displayName: [Int: String] = [
        CustomFont.system.rawValue: "시스템 폰트",
        CustomFont.dovemayo.rawValue: "둘기마요"
    ]
    
    /// 기본 폰트 딕셔너리
    static var regular: [Int: String] = [
        CustomFont.system.rawValue: "AppleSDGothicNeo-Regular",
        CustomFont.dovemayo.rawValue: "Dovemayo-Medium"
    ]
    
    /// 볼드 폰트 딕셔너리
    static var bold: [Int: String] = [
        CustomFont.system.rawValue: "AppleSDGothicNeo-Bold",
        CustomFont.dovemayo.rawValue: "Dovemayo-Bold"
    ]
    
    var displayName: String {
        CustomFont.displayName[self.rawValue] ?? "시스템 폰트"
    }

    /// 기본 폰트 이름
    var regular: String {
        CustomFont.regular[self.rawValue] ?? "AppleSDGothicNeo-Regular"
    }
    
    /// 볼드 폰트 이름
    var bold: String {
        CustomFont.bold[self.rawValue] ?? "AppleSDGothicNeo-Bold"
    }
}
