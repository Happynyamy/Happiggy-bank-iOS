//
//  NewNoteTextViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/19.
//

import UIKit

/// 새 쪽지 추가 텍스트 뷰에 필요한 형식으로 데이터를 변환해주는 뷰모델
final class NewNoteTextViewModel {
    
    // MARK: - Properties
    
    /// 임시 쪽지 객체
    var newNote: NewNote!
    
    /// 강조 색깔
    var tintColor: UIColor {
        UIColor.noteHighlight(for: newNote.color)
    }
    
    /// 배경 색깔
    var backgroundColor: UIColor {
        UIColor.note(color: newNote.color)
    }

    /// 달력 버튼 제목
    var attributedDateButtonTitle: NSMutableAttributedString {
        let string = self.attributedYearString
        string.append(.init(string: StringLiteral.spacing))
        string.append(self.attributedMonthDayString)

        return string
    }
    
    /// 색깔 적용하고 볼드처리한 연도 텍스트
    private var attributedYearString: NSMutableAttributedString {
        self.newNote.date
            .yearString
            .nsMutableAttributedStringify()
            .bold(fontSize: Font.secondaryText)
    }
    
    /// 색깔 적용한 월, 일 텍스트
    private var attributedMonthDayString: NSMutableAttributedString {
        self.newNote.date
            .monthDotDayWithDayOfWeekString
            .nsMutableAttributedStringify()
    }
    
    
    // MARK: - Inits
    
    init(date: Date, bottle: Bottle) {
        self.newNote = NewNote(date: date, bottle: bottle)
    }
    
    
    // MARK: - Functions
    
    /// 색깔 적용한 글자수 라벨 텍스트
    func attributedLetterCountString(count: Int) -> NSMutableAttributedString {
        let color = (count > NewNoteTextViewController.Metric.noteTextMaxLength) ?
        UIColor.customWarningLabel : self.tintColor
        
        let countString = "\(count)"
            .nsMutableAttributedStringify()
            .bold(fontSize: Font.secondaryText)
            .color(color: color)
        
        countString.append(StringLiteral.letterCountText.nsMutableAttributedStringify())

        return countString
    }
}
