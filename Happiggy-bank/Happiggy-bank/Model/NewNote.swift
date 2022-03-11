//
//  NewNote.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/11.
//

import Foundation

/// 새 쪽지를 추가할 때 사용하는 모델
struct NewNote {
    
    /// 작성 날짜
    var date: Date
    
    /// 선택한 색깔
    var color = NoteColor.default
    
    /// 담을 저금통
    var bottle: Bottle
}
