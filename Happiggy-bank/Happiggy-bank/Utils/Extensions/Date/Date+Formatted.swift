//
//  Date+Formatted.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/28.
//

import Foundation

import Then

extension Date {
    
    /// DateFormat case 에 맞게 날짜를 변환하는 date formatter
    /// 현재는 한글로 픽스, internationalize 시 변경 필요
    private static func formatter(type: DateFormat) -> DateFormatter {
        DateFormatter().then {
            switch type {
            case .dot:
                $0.dateFormat = "yyyy.MM.dd"
            case .letters:
                // need to make dateStyle medium for eng..
                $0.dateStyle = .long
                $0.timeStyle = .none
            case .spaceAndDot:
                $0.dateFormat = "yyyy MM.dd"
            case .spaceAndDotWithDayOfWeek:
                $0.dateFormat = "yyyy MM.dd  EEEEE"
            case .abbreviatedDot:
                $0.dateFormat = "yy.MM.dd"
            }
            $0.locale = Locale(identifier: krLocalIdentifier)
        }
    }
    
    /// 변환하고 싶은 문자열 포맷을 입력하면 해당 포맷의 문자열로 반환
    private static func format(dateFormat: String, date: Date) -> String {
        DateFormatter().then {
            $0.dateFormat = dateFormat
            $0.locale = Locale(identifier: krLocalIdentifier)
        }.string(from: date)
    }
    
    /// DateFormat 케이스에 맞게 날짜를 문자열로 변환해주는 메서드
    /// .spaceAndDot : 2022 02.05
    /// .spaceAndDotWithDayOfWeek : 2022 02.05 금
    /// .letters : 2022년 2월 5일
    /// .dot : 2022.02.05
    /// .abbreviatedDot : 22.02.05
    func customFormatted(type: DateFormat) -> String {
        Date.formatter(type: type).string(from: self)
    }
    
    /// 연도를 "2022" 형태의 문자열로 반환
    var yearString: String {
        Date.format(dateFormat: "yyyy", date: self)
    }
    
    /// 월, 일을 "02.05  월" 형태의 문자열로 반환
    var monthDotDayString: String {
        Date.format(dateFormat: "MM.dd", date: self)
    }
    
    /// 월, 일은 "02.05  토" 형태의 문자열로 반환
    var monthDotDayWithDayOfWeekString: String {
        Date.format(dateFormat: "MM.dd  EEEEE", date: self)
    }
}
