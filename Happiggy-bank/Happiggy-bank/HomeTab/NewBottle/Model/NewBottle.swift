//
//  NewBottle.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/13.
//

import Foundation

/// 새 저금통 생성시 사용되는 데이터 모델
struct NewBottle {
    
    /// 저금통 이름
    var name: String?
    
    /// 저금통 개봉 시점의 인덱스
    var periodIndex: Int?
    
    /// 저금통 개봉 날짜
    var endDate: Date?
    
    /// 저금통 개봉 멘트
    var openMessage: String?
}
