//
//  NoteDatePickerData.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/11.
//

import Foundation

/// 날짜피커 데이터 소스로 사용하기 위해 선언한 구조체
struct NoteDatePickerData {
    
    /// 날짜
    var date: Date
    
    /// 해당 날짜에 쪽지가 있다면 쪽지의 색깔을 나타내는 NoteColor case, 없다면 nil
    var color: NoteColor?
}
