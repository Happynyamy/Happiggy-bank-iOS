//
//  Date+Formatted.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/28.
//

import Foundation

import Then

extension Date {
    
    /// 한글로는 "xxxx년 x월 x일", 영어로는 "February 28, 2022" 형태로 날짜를 변환하는 date formatter
    /// 현재는 한글로 픽스, internationalize 시 변경 필요
    private static let formatter = DateFormatter().then {
        // need to make dateStyle medium for eng..
        $0.dateStyle = .long
        $0.timeStyle = .none
        $0.locale = Locale(identifier: krLocalIdentifier)
    }
    
    /// 날짜를 한글로는 "xxxx년 x월 x일", 영어로는 "February 28, 2022" 형태의 문자열로 변환해 반환하는 메서드
    func customFormatted() -> String {
        Date.formatter.string(from: self)
    }
}
