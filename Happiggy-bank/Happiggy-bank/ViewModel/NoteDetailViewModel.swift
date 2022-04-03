//
//  NoteDetailViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/30.
//

import UIKit

/// 쪽지 디테일 뷰 컨트롤러의 뷰모델
final class NoteDetailViewModel {
    
    // MARK: - Properties
    
    /// 쪽지들
    var notes: [Note]!
    
    /// 유저가 처음 선택한 쪽지의 인덱스
    var selectedIndex: Int!
    
    
    // MARK: - Init
    
    init(notes: [Note], selectedIndex: Int) {
        self.notes = notes
        self.selectedIndex = selectedIndex
    }
    
    
    // MARK: - Functions
    
    /// 연도를 색상을 바꿔서 문자열로 리턴
    func attributedYearString(forNote note: Note) -> NSMutableAttributedString {
        note.date
            .yearString
            .nsMutableAttributedStringify()
            .color(color: .noteHighlight(for: note.color))
    }
    
    /// 월, 일, 요일을 색상을 바꿔서 문자열로 리턴
    func attributedMonthAndDayString(forNote note: Note) -> NSMutableAttributedString {
        note.date
            .monthDotDayWithDayOfWeekString
            .nsMutableAttributedStringify()
            .color(color: .noteHighlight(for: note.color))
    }
    
    /// 색상에 따른 쪽지 이미지 리턴
    func image(for note: Note) -> UIImage {
        UIImage(named: StringLiteral.listNote + note.color.capitalizedString) ?? UIImage()
    }
}
