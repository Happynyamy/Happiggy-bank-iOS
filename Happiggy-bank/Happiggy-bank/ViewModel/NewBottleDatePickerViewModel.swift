//
//  NewBottleDatePickerViewModel.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/06.
//

import Foundation

/// NewBottleDatePickerViewController에서 사용하는 데이터 가공해주는 뷰모델
final class NewBottleDatePickerViewModel {
    
    /// 저장할 유리병 데이터
    var bottleData: NewBottle?
    
    /// 선택된 period의 index에 따라 종료 날짜 생성
    func endDate(from startDate: Date, after periodIndex: Int) -> Date {
        let period = NewBottleDatePickerViewController.pickerValues[periodIndex]
        guard let constant = NewBottleDatePickerViewController.pickerConstants[period]
        else { return Date() }
        
        // week
        if periodIndex == 0 {
            guard let endDate = Calendar.current.date(
                byAdding: DateComponents(day: constant + 1),
                to: startDate
            )
            else { return Date() }
            return Calendar.current.startOfDay(for: endDate)
        }
        
        // month
        if (1...3) ~= periodIndex {
            guard let endDate = Calendar.current.date(
                byAdding: DateComponents(month: constant, day: 1),
                to: startDate
            )
            else { return Date() }
            return Calendar.current.startOfDay(for: endDate)
        }
        
        // year
        if periodIndex == 4 {
            guard let endDate = Calendar.current.date(
                byAdding: DateComponents(year: constant, day: 1),
                to: startDate
            )
            else { return Date() }
            return Calendar.current.startOfDay(for: endDate)
        }
        
        return Date()
    }
    
    /// 개봉 예정일 표시하는 문자열 생성
    func openDateString(of endDate: Date) -> String {
        return StringLiteral.openDateLabelPrefix + endDate.customFormatted(type: .letters)
    }
}
