//
//  DateFormat.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import Foundation

/// DateFormatter 를 사용해서 반환할 문자열 형식
enum DateFormat {
    
    /// 2022.02.05 형태
    case dot
    
    /// 2022년 2월 5일 형태
    case letters
    
    /// 2022 02.05 형태
    case spaceAndDot
    
    /// 2022년 2월 5일  금 형태
    case spaceAndDotWithDayOfWeek
    
    /// 22.02.05 형태
    case abbreviatedDot
}
