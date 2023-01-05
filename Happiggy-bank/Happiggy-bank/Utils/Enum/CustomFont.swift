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
    
    /// 고운바탕
    case gowunBatang
    
    /// 둘기마요
    case dovemayo

    /// 카페24 써라운드
    case cafe24
    
    /// IBM Plex Sans
    case ibmPlex
    
    /// J개구쟁이
    case gaegu
}

extension CustomFont {
    
    
    // MARK: - Properties

    /// 현재 폰트
    static var current: CustomFont {
        let key = UserDefaults.Key.font.rawValue
        guard let rawValue = UserDefaults.standard.value(forKey: key) as? Int
        else {
            return .system
        }

        return CustomFont(rawValue: rawValue) ?? .system
    }
    
    /// 뷰에 표시할 이름
    static var displayName: [Int: String] = [
        CustomFont.system.rawValue: "시스템 폰트",
        CustomFont.dovemayo.rawValue: "둘기마요",
        CustomFont.gowunBatang.rawValue: "고운바탕",
        CustomFont.gaegu.rawValue: "J개구쟁이",
        CustomFont.cafe24.rawValue: "카페24 써라운드",
        CustomFont.ibmPlex.rawValue: "IMB Plex Sans"
    ]
    
    /// 기본 폰트 딕셔너리
    static var regular: [Int: String] = [
        CustomFont.system.rawValue: "AppleSDGothicNeo-Regular",
        CustomFont.dovemayo.rawValue: "Dovemayo-Medium",
        CustomFont.gowunBatang.rawValue: "GowunBatang-Regular",
        CustomFont.gaegu.rawValue: "Gaegu-Regular",
        CustomFont.cafe24.rawValue: "Cafe24Ssurroundair",
        CustomFont.ibmPlex.rawValue: "IBMPlexSansKR"
    ]
    
    /// 볼드 폰트 딕셔너리
    static var bold: [Int: String] = [
        CustomFont.system.rawValue: "AppleSDGothicNeo-Bold",
        CustomFont.dovemayo.rawValue: "Dovemayo-Bold",
        CustomFont.gowunBatang.rawValue: "GowunBatang-Bold",
        CustomFont.gaegu.rawValue: "Gaegu-Bold",
        CustomFont.cafe24.rawValue: "Cafe24Ssurround",
        CustomFont.ibmPlex.rawValue:  "IBMPlexSansKR-Bold"
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
