//
//  UpdateSender.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/08.
//

import Foundation

/// 데이터가 업데이트됐다는 것을 알리는 델리게이트
protocol UpdateSender {
    
    /// 업데이트됐음을 알리는 함수
    func sendUpdate()
}
