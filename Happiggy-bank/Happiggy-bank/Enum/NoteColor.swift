//
//  NoteColor.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/12.
//

import Foundation

/// 쪽지 색상들을 모아둔 enum 으로 상황별로 기본 문자열에 이하 문자열을 접두사/접미사로 붙여서 불러올 애셋 이름을 완성
/// e.g MainViewNote + NoteColors.white.capitalizedString
enum NoteColor: String, CaseIterable {
    
    /// 흰색 쪽지
    case white
    
    /// 분홍 쪽지
    case pink
    
    /// 보라 쪽지
    case purple

    /// 연두 쪽지
    case green

    /// 노랑 쪽지
    case yellow
    
    /// 기본 쪽지 색깔
    static let `default` = white
    
    /// 이미지 에셋은 현재 "noteYellow" 와 같은 형태라 rawValue 의 첫 글자를 대문자로 바꿔주기 위함
    var capitalizedString: String {
        self.rawValue.capitalized
    }
}
