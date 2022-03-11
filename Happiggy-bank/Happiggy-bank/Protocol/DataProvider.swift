//
//  DataProvider.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/10.
//

import Foundation

/// 뷰 컨트롤러간 데이터 전송을 위한 Delegate
protocol DataProvider {
    
    /// 새 유리병 데이터를 전송하는 함수
    func sendNewBottleData(_ data: NewBottle)
}

// MARK: 추후 Coredata Bottle Entity로 사용 예정 (테스트용 임시 모델)
struct NewBottle {
    var name: String?
    var periodIndex: Int?
}
