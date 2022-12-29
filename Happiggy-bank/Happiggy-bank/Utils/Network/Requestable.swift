//
//  Requestable.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/29.
//

import Foundation

/// HTTP 요청을 생성할 수 있는 타입
protocol Requestable {
    var urlString: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var httpBody: Data? { get }
}
