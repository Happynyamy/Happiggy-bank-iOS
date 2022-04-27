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
    private(set) var selectedIndex: Int!
    
    /// 저금통 제목
    private(set) var bottleTitle: String!
    
    
    // MARK: - Init
    
    init(notes: [Note], selectedIndex: Int, bottleTitle: String) {
        self.notes = notes
        self.selectedIndex = selectedIndex
        self.bottleTitle = bottleTitle
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
    
    /// 인덱스 라벨 문자열 리턴
    func attributedIndexString(_ index: Int) -> NSMutableAttributedString {
        let indexString = "\(index + 1)"
            .nsMutableAttributedStringify()
            .color(color: .customLabel)
            .bold(fontSize: Font.indexLabel)
        
        let totalCountString = "/\(self.notes.count)"
            .nsMutableAttributedStringify()
        
        indexString.append(totalCountString)
        
        return indexString
    }
    
    /// 인덱스에 해당하는 쪽지의 색깔에 맞는 캐릭터 이미지 리턴
    func characterImage(forIndex index: Int) -> UIImage {
        let color = self.notes[index].color
        
        return .character(color: color)
    }
}
