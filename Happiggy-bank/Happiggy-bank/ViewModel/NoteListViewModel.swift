//
//  NoteListViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

/// 쪽지에 필요한 형식으로 데이터를 변환해주는 뷰모델
final class NoteListViewModel {
    
    // MARK: - Properties
    
    /// 리스트에서 나타낼 쪽지들의 배열
    var notes: [Note]!
    
    /// 모든 쪽지가 다 개봉되었는지 여부
    var allNotesAreOpen: Bool {
        self.notes.first { !$0.isOpen } == nil ? true : false
    }
    
    /// 개봉하지 않은 쪽지들
    var enumeratedUnopenNotes: [(offset: Int, element: Note)] {
        self.notes.enumerated().filter { !$1.isOpen }
    }
    
    /// 유리병 제목
    private(set) lazy var bottleTitle: String = {
        self.notes.first?.bottle.title ?? StringLiteral.emptyString
    }()
    
    /// 쪽지 전체 개수
    private(set) lazy var numberOfTotalNotes: Int = {
        self.notes.count
    }()
    
    /// 쪽지 개수 라벨 문자열
    private(set) lazy var noteCountLabelString: String = {
        StringLiteral.noteCountLabelString(count: self.numberOfTotalNotes)
    }()
    
    
    // MARK: - Functions
    
    /// 날짜를 "2022 02.05" 형태의 문자열로 연도만 볼드 처리해서 변환
    func attributedDateString(for note: Note) -> NSMutableAttributedString {
        note.date
            .customFormatted(type: .spaceAndDot)
            .nsMutableAttributedStringify()
            .color(color: .highlight(color: note.color))
            .bold(targetString: note.date.yearString, fontSize: Font.dateLabelFontSize)
    }
    
    /// 색상에 따른 쪽지 이미지 리턴
    func image(for note: Note) -> UIImage {
        UIImage(named: StringLiteral.listNote + note.color.capitalizedString) ?? UIImage()
    }
}
