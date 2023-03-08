//
//  NoteDetailListViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/06.
//

import Foundation

/// NoteDetailListViewContoller의 뷰모델
final class NoteDetailListViewModel {

    // MARK: - Properties

    /// 유저가 처음 선택한 쪽지의 인덱스
    let selectedIndex: Int

    /// 쪽지 뷰 모델 배열
    let noteViewModels: [NoteDetailCellViewModel]

    /// 저금통 제목
    let bottleTitle: String


    // MARK: - Init

    init(notes: [Note], selectedIndex: Int, bottleTitle: String) {
        let count = notes.count
        let imageManager = ImageManager()
        self.noteViewModels = notes.enumerated().map {
            NoteDetailCellViewModel(
                note: $0.element,
                index: $0.offset,
                numberOfTotalNotes: count,
                imageManager: imageManager
            )
        }
        self.selectedIndex = selectedIndex
        self.bottleTitle = bottleTitle
    }


    // MARK: - Funtions

    func noteViewModel(forRow row: Int, id: UUID) -> NoteDetailCellViewModel? {
        guard let noteViewModel = self.noteViewModels[safe: row],
              noteViewModel.id == id
        else {
            return nil
        }

        return noteViewModel
    }
}


// MARK: - Mock Data
extension NoteDetailListViewModel {

    static let foo = {
        let bottle = Bottle.fooOpened()
        let selectedIndex = bottle.notes.indices.randomElement()!

        return NoteDetailListViewModel(
            notes: bottle.notes,
            selectedIndex: selectedIndex,
            bottleTitle: bottle.title
        )
    }()
}
