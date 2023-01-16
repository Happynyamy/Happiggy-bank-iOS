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

    /// 기본 폰트 이름
    var regular: String {
        switch self {
        case .system:
            return "AppleSDGothicNeo-Regular"
        case .gowunBatang:
            return "GowunBatang-Regular"
        case .dovemayo:
            return "Dovemayo-Medium"
        case .cafe24:
            return "Cafe24Ssurroundair"
        case .ibmPlex:
            return "IBMPlexSansKR"
        case .gaegu:
            return "Gaegu-Regular"
        }
    }

    /// 볼드 폰트 이름
    var bold: String {
        switch self {
        case .system:
            return "AppleSDGothicNeo-Bold"
        case .gowunBatang:
            return "GowunBatang-Bold"
        case .dovemayo:
            return "Dovemayo-Bold"
        case .cafe24:
            return "Cafe24Ssurround"
        case .ibmPlex:
            return "IBMPlexSansKR-Bold"
        case .gaegu:
            return "Gaegu-Bold"
        }
    }
}


// MARK: - CustomStringConvertible
extension CustomFont: CustomStringConvertible {

    var description: String {
        switch self {
        case .system:
            return "시스템 폰트"
        case .gowunBatang:
            return "고운바탕"
        case .dovemayo:
            return "둘기마요"
        case .cafe24:
            return "카페24 써라운드"
        case .ibmPlex:
            return "IBM Plex Sans"
        case .gaegu:
            return "J개구쟁이"
        }
    }
}
