//
//  NoteDetailCellViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/06.
//

import UIKit

/// NoteDetailCell의 뷰모델
final class NoteDetailCellViewModel {

    // MARK: - Properties

    let id: UUID

    /// 현재 쪽지의 인덱스 값
    let index: Int

    /// 전체 쪽지 개수
    let numberOfTotalNotes: Int

    /// 배경 색상
    let backgroundColor: UIColor?

    /// 테두리 줄 색상
    let lineColor: UIColor?

    /// 글자 색상
    let textColor: UIColor?

    let yearString: String

    let dateString: String

    let contentString: String

    /// 사진 있는지 여부
    var hasPhoto: Bool { self.note.imageURL != nil }

    /// 사진을 탭했을 때 호출되는 클로저
    var photoDidTap: ((UIImage) -> Void)?

    /// 쪽지 객체
    private let note: Note

    private let imageManager: ImageManager


    // MARK: - Init(s)

    init(note: Note, index: Int, numberOfTotalNotes: Int, imageManager: ImageManager) {
        self.note = note
        self.id = note.id
        self.index = index + 1
        self.numberOfTotalNotes = numberOfTotalNotes
        self.imageManager = imageManager
        self.backgroundColor = AssetColor.noteBG(for: self.note.color)
        self.lineColor = AssetColor.noteLine(for: self.note.color)
        self.textColor = AssetColor.noteText(for: self.note.color)
        self.yearString = self.note.date.yearString
        self.dateString = self.note.date.monthDotDayWithDayOfWeekString
        self.contentString = self.note.content
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


// MARK: - Constants
fileprivate extension NoteDetailCellViewModel {

    enum StringLiteral {
        static let slash = "/"
    }
}
