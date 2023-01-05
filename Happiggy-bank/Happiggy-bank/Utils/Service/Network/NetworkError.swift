//
//  NetworkError.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/29.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidRequest
    case transportError
    case serverSideError(statusCode: Int?)
    case decodingFailure


    // MARK: - Properties

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .transportError:
            return "통신 에러가 발생했습니다"
        case .serverSideError(let statusCode):
            let statusCodeIfNeeded = statusCode != nil ? " 상태코드: \(statusCode!)" : .empty
            return "서버에 에러가 발생했습니다.\(statusCodeIfNeeded)"
        case .decodingFailure:
            return "디코딩에 실패했습니다."
        }
    }
}
