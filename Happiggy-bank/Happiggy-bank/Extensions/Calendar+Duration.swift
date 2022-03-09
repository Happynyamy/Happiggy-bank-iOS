//
//  Calendar+Duration.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/09.
//

import Foundation

extension Calendar {
    
    /// 저금통 기한 디폴트값(일단 그냥 임의로 1년 넣음)
    private static let defaultDuration = 364
    
    /// 두 날짜 사이의 기간(시작일, 종료일 포함)을 계산하는 메서드
    static func daysBetween(start startDate: Date, end endDate: Date) -> Int {
        let start = self.current.startOfDay(for: startDate)
        let end = self.current.startOfDay(for: endDate)
        let duration = self.current.dateComponents([.day], from: start, to: end).day ?? self.defaultDuration
        return duration + 1
    }
}
