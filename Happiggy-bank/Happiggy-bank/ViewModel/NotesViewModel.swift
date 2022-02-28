//
//  NotesViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/26.
//

import UIKit

struct MockNote {
    let date: Date
    let color: UIColor
    let content: String!
}

/// NotesView 에 필요한 형태로 데이터를 변환
class NotesViewModel {
    
    // TODO: Change to private set
    /// 현재 유리병의 전체 쪽지 배열
    var notes: [MockNote] = [
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil),
        MockNote(date: Date(), color: .systemYellow, content: nil)
    ]
    
    /// 선택된 쪽지에 해당되는 이미지를 리턴하는 메서드(추후 변경 예정)
    func image(for: MockNote) -> UIColor {
        [UIColor.systemGreen, .systemOrange, .systemIndigo, .systemYellow].randomElement()!
    }
}
