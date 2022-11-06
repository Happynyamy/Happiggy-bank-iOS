//
//  UIImage+AssetImages.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/18.
//

import UIKit

extension UIImage {
    
    // MARK: - Properties
    
    // MARK: Buttons
    
    /// 확인(체크) 아이콘
    static let customCheckmark = UIImage(named: Asset.checkmark.rawValue) ?? .checkmark
    
    /// 다음 아이콘: >
    static let customNext = UIImage(named: Asset.next.rawValue)
    
    /// 뒤로가기 아이콘: <
    static let customBack = UIImage(named: Asset.back.rawValue)
    
    /// 취소 아이콘 : X
    static let customXmark = UIImage(named: Asset.xmark.rawValue)
    
    
    // MARK: Tab bar Buttons
    
    /// 탭바 홈 아이콘 기본 상태
    static let homeIconNormal = UIImage(named: Asset.tabBarHomeNormal.rawValue)
    
    /// 탭바 홈 아이콘 선택 상태
    static let homeIconSelected = UIImage(named: Asset.tabBarHomeSelected.rawValue)
    
    /// 탭바 리스트 아이콘 기본 상태
    static let listIconNormal = UIImage(named: Asset.tabBarListNormal.rawValue)
    
    /// 탭바 리스트 아이콘 선택 상태
    static let listIconSelected = UIImage(named: Asset.tabBarListSelected.rawValue)
    
    /// 탭바 환경설정 아이콘 보통 상태
    static let settingsIconNormal = UIImage(named: Asset.tabBarSettingsNormal.rawValue)

    /// 탭바 환경설정 아이콘 선택 상태
    static let settingsIconSelected = UIImage(named: Asset.tabBarSettingsSelected.rawValue)

    
    // MARK: Home View Images
    
    /// 홈 라이트모드 배경
    static let homeBackgroundLight = UIImage(named: Asset.homeBackgroundLight.rawValue)
    
    /// 홈 저금통 뚜껑
    static let homeBottleCap = UIImage(named: Asset.homeBottleCap.rawValue)
    
    /// 홈 저금통 앞면
    static let homeBottleFront = UIImage(named: Asset.homeBottleFront.rawValue)
    
    /// 홈 저금통 뒷면
    static let homeBottleBack = UIImage(named: Asset.homeBottleBack.rawValue)
    
    /// 홈 저금통 밑 그림자
    static let homeBottleShadow = UIImage(named: Asset.homeBottleShadow.rawValue)
    
    /// 블러 처리된 홈 라이모드 배경 (팝업용)
    static let blurredHomeBackgroundLight = UIImage(
        named: Asset.homeBackgroundBlurredLight.rawValue
    )
    
    
    // MARK: BottleViewImages
    
    /// 저금통 리스트 셀 라이트모드 배경
    static let bottleListCellBackgroundLight = UIImage(
        named: Asset.bottleCellBackgroundLight.rawValue
    )
    
    /// 저금통 리스트 저금통 앞면
    static let bottleListBottleBack = UIImage(named: Asset.bottleListBottleBack.rawValue)

    /// 저금통 리스트 저금통 뒷면
    static let bottleListBottleFront = UIImage(named: Asset.bottleListBottleFront.rawValue)


    // MARK: BorderdNoteImage

    /// 테두리가 있는 쪽지 배경 이미지
    static let borderedNoteBackground = UIImage(named: "textViewNote")


    // MARK: - Functions
    
    /// 쪽지 에셋 이미지를 반환하는 메서드
    static func note(color: NoteColor) -> UIImage {
        UIImage(named: Asset.note.rawValue + color.capitalizedString) ?? UIImage()
    }
    
    /// 캐릭터 에셋 이미지를 반환하는 메서드
    static func character(color: NoteColor) -> UIImage {
        UIImage(named: Asset.character.rawValue + color.capitalizedString) ?? UIImage()
    }
}
