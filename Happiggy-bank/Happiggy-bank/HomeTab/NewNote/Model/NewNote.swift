//
//  NewNote.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/11.
//

import Foundation

/// 새 쪽지를 추가할 때 사용하는 모델
final class NewNote {

    // MARK: - Properties

    /// 고유 아이디
    let id = UUID()
    
    /// 작성 날짜
    var date: Date
    
    /// 선택한 색깔
    var color = NoteColor.default
    
    /// 담을 저금통
    var bottle: Bottle

    /// 이미지 아이디
    var imageID: String?


    // MARK: - Init(s)

    init(date: Date, bottle: Bottle) {
        self.date = date
        self.bottle = bottle
    }
}


// MARK: - Equtable
extension NewNote: Equatable {
    static func == (lhs: NewNote, rhs: NewNote) -> Bool {
        lhs.id == rhs.id
    }
}
