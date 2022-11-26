//
//  PhotoNoteCellViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/11/06.
//

import UIKit

/// PhotoNoteCell의 뷰모델
final class PhotoNoteCellViewModel {

    // MARK: - Properties

    /// 사진 있는지 여부
    var hasPhoto: Bool {
        self.note.imageURL != nil
    }
    
    /// 사진을 탭했을 때 호출되는 클로저
    var photoDidTap: ((UIImage) -> Void)?

    /// 색상, 부분 강조 표시를 적용한 날짜 문자열
    private(set) lazy var attributedDateString: NSMutableAttributedString = {
        var date = String.empty.nsMutableAttributedStringify()
        let year = note.date.yearString
            .nsMutableAttributedStringify()
            .bold(fontSize: FontSize.secondaryLabel)
        let spacedMonthAndDay = " \(note.date.monthDotDayWithDayOfWeekString)"
            .nsMutableAttributedStringify()

        date.append(year)
        date.append(spacedMonthAndDay)
        date.color(color: self.tintColor)

        return date
    }()

    /// 색상, 부분 강조 표시를 적용한 인덱스 문자열
    private(set) lazy var attributedIndexString: NSMutableAttributedString = {
        var result = String.empty.nsMutableAttributedStringify()
        let index = self.index.description.nsMutableAttributedStringify()
            .color(color: self.tintColor)
            .bold(fontSize: FontSize.secondaryLabel)
        let total = "/\(self.numberOfTotalNotes.description)".nsMutableAttributedStringify()

        result.append(index)
        result.append(total)

        return result
    }()

    /// 유저가 작성한 내용
    private(set) lazy var attributedContentString: NSMutableAttributedString = {
        self.note.content.nsMutableAttributedStringify()
    }()

    /// 기본 색상
    private(set) lazy var basicColor: UIColor = { .note(color: self.note.color) }()

    /// 강조 색상
    private(set) lazy var tintColor: UIColor = { .noteHighlight(for: self.note.color) }()

    /// 쪽지 객체
    private let note: Note

    /// 전체 쪽지 개수
    private let numberOfTotalNotes: Int

    /// 현재 쪽지의 인덱스 값
    private let index: Int

    private let imageManager: ImageManager


    // MARK: - Init(s)

    init(note: Note, index: Int, numberOfTotalNotes: Int, imageManager: ImageManager) {
        self.note = note
        self.index = index + 1
        self.numberOfTotalNotes = numberOfTotalNotes
        self.imageManager = imageManager
    }


    // MARK: - Functions

    /// 유저가 저장한 사진을 리턴
    func photo() -> UIImage? {
        guard let url = note.imageURL
        else {
            return nil
        }

        return self.imageManager.image(forNote: note.id, imageURL: url) ?? .error
    }
}
