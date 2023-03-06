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

    /// 이미지 처리 객체
    let imageMananger = ImageManager()
    
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

    /// 테두리 색깔
    var borderColor: UIColor {
        UIColor.noteBorder(for: newNote.color)
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
            .bold()
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
            .bold()
            .color(color: color)
        
        countString.append(StringLiteral.letterCountText.nsMutableAttributedStringify())

        return countString
    }

    /// 이미지를 저장하고, 성공한 경우 경로 엔드포인트를, 실패한 경우 nil 리턴
    func saveImage(_ image: UIImage) -> String? {
        guard let imageID = newNote.imageID
        else {
            return nil
        }

        return self.imageMananger.saveImage(image, noteID: newNote.id, imageID: imageID)
    }

    /// 인자로 주어진 경로에 있는 이미지를 삭제
    /// 
    /// 삭제에 실패하는 경우 한 번 더 시도하고 리턴
    func deleteImage(withImageURL imageURL: String) {
        guard !self.imageMananger.deleteImage(forNote: newNote.id, imageURL: imageURL)
        else {
            return
        }

        self.imageMananger.deleteImage(forNote: newNote.id, imageURL: imageURL)
    }
}
