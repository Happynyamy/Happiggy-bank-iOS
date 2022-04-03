//
//  UIColor+AssetColors.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

extension UIColor {
    
    // MARK: - Properties
    
    /// 환경 설정에 사용하는 회색
    static let customGray = uicolor(named: "customGray")
    
    /// 저금통 리스트 날짜 라벨 색상
    static let bottleListDateLabel = uicolor(named: "bottleListDateLabelColor")
    
    /// 저금통 텍스트필드 플레이스홀더 색상
    static let customPlaceholderText = uicolor(named: "placeholderTextColor")
    
    /// 메인 라벨 색상: 저금통 텍스트필드 텍스트, 피커 선택 행 텍스트, 저금통 리스트 저금통 제목, 환경설정 알림 토글버튼에 사용
    static let customLabel = uicolor(named: "primaryLabelColor")
    
    /// 두번째 라벨 색상: 저금통 텍스트 필드 아래 안내 라벨, 환경 설정 버전 정보 라벨에 사용
    static let customSecondaryLabel = uicolor(named: "secondaryLabelColor")
    
    /// 경고 라벨 색상: 저금통 텍스트 필드, 쪽지 날짜 피커, 쪽지 텍스트 뷰에서 내용이 없을 때 경고하는 데 사용
    static let customWarningLabel = UIColor(named: "warningLabelColor")
    
    /// 피커 selector 색상
    static let pickerSelectionColor = UIColor(named: "pickerSelectionColor")
    
    /// 연한 회색
    static let customLightGray = UIColor(named: "customLightGray")
    
    /// 쪽지 리스트 태그 셀 흰색 쪽지 색상
    static let tagCellWhite = UIColor(named: "noteListTagWhite")
    
    
    // MARK: - Functions
    
    private static func uicolor(named name: String) -> UIColor {
        UIColor(named: name) ?? .label
    }
    
    /// 애셋에 추가한 쪽지 하이라이트 색상을 반환하는 메서드
    static func noteHighlight(for color: NoteColor) -> UIColor {
        UIColor(named: Asset.noteHighlight.rawValue + color.capitalizedString) ?? .systemGray3
    }
    
    /// 애셋에 추가한 쪽지 색상을 반환하는 메서드
    static func note(color: NoteColor) -> UIColor {
        UIColor(named: Asset.note.rawValue + color.capitalizedString) ?? .white
    }
    
    /// 에셋에 추가한 쪽지 외곽선 색상을 반환하는 메서드
    static func noteBorder(for color: NoteColor) -> UIColor {
        UIColor(named: Asset.noteBorder.rawValue + color.capitalizedString) ?? .customGray
    }
}
