//
//  DataProvider.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/10.
//

import Foundation

/// 뷰 컨트롤러간 데이터 전송을 위한 Delegate
protocol DataProvider {
    
    // TODO: 리팩토링 완료시 삭제하기
    /// 새 유리병 데이터를 전송하는 함수
    func sendNewBottleData(_ data: NewBottle)
    
    /// 새 유리병 데이터를 전송하는 함수
    func send(_ data: NewBottle)
}

// Optional Protocol을 위한 정의
// @objc protocol을 사용해 정의하는 것이 Swift 가이드에 나와있는대로지만 NewBottle 타입이 objective-C로 번역이 안돼 대안 사용
extension DataProvider {
    
    func sendNewBottleData(_ data: NewBottle) { }
    
    func send(_ data: NewBottle) { }
}
