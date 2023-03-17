//
//  NewNoteDatePickerViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새 쪽지 추가 날짜 피커에 필요한 형식으로 데이터를 변환해주는 뷰모델
final class NewNoteDatePickerViewModel {
    
    // MARK: - Properties

    let newNote: NewNote

    /// 오늘 날짜 혹은 이전에 선택한 날짜에 해당하는 행 위치를 리턴
    let initialRow: Int

    /// 날짜 피커 전체 행 개수
    let numberOfRows: Int

    /// 선택한 날짜
    ///
    /// 피커를 스크롤만 하고 체크 버튼으로 확정하지 않는 경우를 분리하기 위해 별도로 선언
    var selectedDate: Date
    
    /// 날짜 피커에 나타낼 데이터 소스 : 시작일부터의 오늘까지의 모든 날짜와, 해당 날짜에 쪽지를 이미 썼으면 컬러가 없으면 nil이 담겨있음
    private(set) lazy var noteData: [NoteDatePickerData] = {
        var source = [NoteDatePickerData]()
        let startDate = self.newNote.bottle.startDate
        
        /// 날짜 먼저 전부 기록
        for value in .zero..<self.numberOfRows {
            let date = Calendar.current.date(byAdding: .day, value: value, to: startDate) ?? Date()
            source.append(NoteDatePickerData(date: date))
        }
        
        /// 쪽지들 확인하면서 맞는 날짜에 색깔 기록
        for note in self.newNote.bottle.notes {
            guard note.date < Date.startOfTomorrow
            else { continue }
            
            let index = Calendar.daysBetween(start: startDate, end: note.date) - 1
            guard source[safe: index] != nil
            else {
                continue
            }

            source[index].color = note.color
        }
        
        return source
    }()

    
    // MARK: - Init

    init(newNote: NewNote) {
        self.newNote = newNote
        self.initialRow = Calendar.daysBetween(start: newNote.bottle.startDate, end: newNote.date) - 1
        self.numberOfRows = newNote.bottle.numberOfDaysSinceStartDate
        self.selectedDate = newNote.date
    }
    
    
    // MARK: - Function
    
    /// 쪽지 에셋 이미지 리턴
    func image(for noteData: NoteDatePickerData) -> UIImage? {
        guard let color = noteData.color
        else { return nil }
        
        return AssetImage.note(ofColor: color)
    }
    
    /// 선택한 행의 날짜에 쪽지를 쓸 수 있는 지 리턴
    func selectedDateIsAvailable(for row: Int) -> Bool {
        guard noteData.indices ~= row
        else {
            return false
        }

        return noteData[row].color == nil
    }
}
