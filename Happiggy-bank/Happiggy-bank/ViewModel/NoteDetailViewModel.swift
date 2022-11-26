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

    /// 유저가 처음 선택한 쪽지의 인덱스
    let selectedIndex: Int

    /// 쪽지 뷰 모델 배열
    let noteViewModels: [PhotoNoteCellViewModel]

    /// 저금통 제목
    let bottleTitle: String!
    
    
    // MARK: - Init
    
    init(notes: [Note], selectedIndex: Int, bottleTitle: String) {
        let count = notes.count
        let imageManager = ImageManager()
        self.noteViewModels = notes.enumerated().map {
            PhotoNoteCellViewModel(
                note: $0.element,
                index: $0.offset,
                numberOfTotalNotes: count,
                imageManager: imageManager
            )
        }
        self.selectedIndex = selectedIndex
        self.bottleTitle = bottleTitle
    }
}
