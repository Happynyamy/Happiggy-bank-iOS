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
    
    /// 선택한 날짜
    var selectedDate: Date!
    
    /// 쪽지를 넣을 저금통: 보틀 뷰 컨트롤러에서 주입받음
    private(set) var bottle: Bottle!
    
    /// 날짜 피커에 나타낼 데이터 소스 : 시작일부터의 오늘까지의 모든 날짜와, 해당 날짜에 쪽지를 이미 썼으면 컬러가 없으면 nil이 담겨있음
    private(set) lazy var noteData: [NoteDatePickerData] = {
        var source = [NoteDatePickerData]()
        let startDate = self.bottle.startDate
        
        /// 날짜 먼저 전부 기록
        for value in .zero..<self.numberOfRows {
            let date = Calendar.current.date(byAdding: .day, value: value, to: startDate) ?? Date()
            source.append(NoteDatePickerData(date: date))
        }
        
        /// 쪽지들 확인하면서 맞는 날짜에 색깔 기록
        for note in self.bottle.notes {
            guard note.date < Date.startOfTomorrow
            else { continue }
            
            let index = Calendar.daysBetween(start: startDate, end: note.date) - 1
            source[index].color = note.color
        }
        return source
    }()
    
    /// 날짜 피커 전체 행 개수
    private(set) lazy var numberOfRows: Int =  {
        self.bottle.numberOfDaysSinceStartDate
    }()
    
    /// 오늘 날짜 혹은 이전에 선택한 날짜에 해당하는 행 위치를 리턴
    private(set) lazy var initialRow: Int = {
        Calendar.daysBetween(start: self.bottle.startDate, end: self.selectedDate) - 1
    }()
    
    
    // MARK: - Init
    
    init(initialDate date: Date, bottle: Bottle) {
        self.selectedDate = date
        self.bottle = bottle
    }
    
    
    // MARK: - Function
    
    /// 날짜를 "2022 02.05  금" 형태의 문자열로 월, 일만 볼드 처리해서 변환
    func attributedDateString(
        for source: NoteDatePickerData,
        isSelected: Bool = false
    ) -> NSMutableAttributedString {

        let color = isSelected && (source.color == nil) ?  UIColor.customTint : .label
        
        return source.date
            .customFormatted(type: .spaceAndDotWithDayOfWeek)
            .nsMutableAttributedStringify()
            .color(color: color)
            .bold(
                targetString: source.date.monthDotDayWithDayOfWeekString,
                fontSize: Font.dateLabelFontSize
            )
    }
    
    /// 쪽지 에셋 이미지 리턴
    func image(for noteData: NoteDatePickerData) -> UIImage? {
        guard let color = noteData.color
        else { return nil}
        
        return .note(color: color)
    }
    
    /// 선택한 행의 날짜에 쪽지를 쓸 수 있는 지 리턴
    func selectedDateIsAvailable(for row: Int) -> Bool {
        noteData[row].color == nil
    }
}
