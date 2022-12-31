//
//  Publisher.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/31.
//

import Foundation

/// T가 변경되면 이를 알리는 타입
protocol Publisher {
    associatedtype Value
    
    // MARK: - Functions

    /// 새로운 구독자를 추가
    func addSubscriber(_ subscriber: AnyObject, handler: @escaping (Value) -> Void)

    /// 인자로 받은 구독자를 제거
    func removeSubscriber(_ subscriber: AnyObject)
}
