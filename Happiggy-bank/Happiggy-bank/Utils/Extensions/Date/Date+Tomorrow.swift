//
//  Date+Tomorrow.swift
//  Happiggy-bank
//
//  Created by sun on 2022/06/08.
//

import Foundation

extension Date {
    
    /// 내일
    static var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: one, to: Date()) ?? Date()
    }
    
    /// 내일 시작: xx시 00분
    static var startOfTomorrow: Date { Calendar.current.startOfDay(for: self.tomorrow) }
    
    private static let one = 1
}
