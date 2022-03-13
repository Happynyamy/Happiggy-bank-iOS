//
//  NoteListViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import Foundation

/// 쪽지에 필요한 형식으로 데이터를 변환해주는 뷰모델
class NoteListViewModel {
    
    // MARK: - Property
    
    /// 리스트에서 나타낼 쪽지들의 배열
    var notes: [Note]!
    
    // TODO: computed property + private set 으로 바꾸기...?
    /// 전체 쪽지 중 한 개도 열어본 적이 없는지 여부
    lazy var isFirstOpen: Bool = {
        self.notes.first { $0.isOpen } == nil
    }()
    
    /// 유리병 제목
    private(set) lazy var bottleTitle: String = {
        self.notes.first?.bottle.title ?? StringLiteral.emptyString
    }()
    
    /// 쪽지 전체 개수
    private(set) lazy var numberOfTotalNotes: Int = {
        self.notes.count
    }()
    
    
    // MARK: - Function
    
    /// 날짜를 "2022 02.05" 형태의 문자열로 연도만 볼드 처리해서 변환
    func attributedDateString(for note: Note) -> NSMutableAttributedString {
        note.date
            .customFormatted(type: .dot)
            .bold(targetString: note.date.yearString, fontSize: Font.dateLabelFontSize)
    }
}
