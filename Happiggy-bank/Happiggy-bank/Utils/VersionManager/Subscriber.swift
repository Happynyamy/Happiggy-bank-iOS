//
//  Subscriber.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/31.
//

import Foundation

/// Publisher의 알림 사항을 구독하는 객체
struct Subscriber<Value> {

    // MARK: - Properties

    let handler: (Value) -> Void
    weak var object: AnyObject?


    // MARK: - Inits


    /// Subscriber 인스턴스를 생성
    /// - Parameters:
    ///   - object: Publisher를 구독하는 객체
    ///   - handler: Publisher가 변경사항을 알리면 실행할 코드 블럭, 만약 UI 코드가 들어가는 경우 반드시 메인 큐에서 실행하도록 해야 함
    init(_ object: AnyObject, handler: @escaping (Value) -> Void) {
        self.object = object
        self.handler = handler
    }
}
