//
//  SettingsViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/06.
//

import UIKit

/// 환경설정 뷰 컨트롤러의 뷰모델
final class SettingsViewModel {
    
    typealias Content = SettingsViewController.Content

    
    // MARK: - Functions
    
    /// 해당 칸의 아이콘 이미지 리턴
    func icon(forContentAt indexPath: IndexPath) -> UIImage? {
        Content.icon[indexPath.row] ?? nil
    }
    
    /// 해당 칸의 제목 리턴
    func title(forContentAt indexPath: IndexPath) -> NSMutableAttributedString? {
        Content.title[indexPath.row]?.nsMutableAttributedStringify()
    }
    
    /// 해당 칸의 설명 리턴
    func informationText(forContentAt indexPath: IndexPath) -> NSMutableAttributedString? {
        let text = Content.informationText[indexPath.row]?.nsMutableAttributedStringify()
        
        if indexPath.row == Content.appVersion.rawValue {
            return text?.color(color: .customTint)
        }
        
        return text
    }
    
    /// 세그웨이가 있다면 해당 세그웨이의 아이디 리턴
    func segueIdentifier(forContentAt indexPath: IndexPath) -> String? {
        Content.segueIdentifier[indexPath.row]
    }
}
