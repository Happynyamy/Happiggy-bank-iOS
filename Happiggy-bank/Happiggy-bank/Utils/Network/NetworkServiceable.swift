//
//  NetworkServiceable.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/29.
//

import Foundation

/// 네트워크 통신 기능을 나타내는 타입
protocol NetworkServiceable {

    /// 주어진 endpoint에서 데이터를 받아와 Decodable한 T 타입으로 리턴하며 실패시 NetworkError를 던짐
    /// - Parameter endpoint: 데이터를 받아올 엔드포인트로 Requestable 프로토콜을 채택
    /// - Returns: T
    func resume<T: Decodable>(for endpoint: Requestable) async throws -> T
}
