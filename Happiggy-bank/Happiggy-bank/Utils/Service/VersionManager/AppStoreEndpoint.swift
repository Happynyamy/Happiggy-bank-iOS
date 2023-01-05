//
//  AppStoreEndpoint.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/30.
//

import Foundation

enum AppStoreEndpoint: Requestable {
    case lookUp


    // MARK: - Properties

    var urlString: String {
        switch self {
        case .lookUp:
            let bundleID = "Happiggy.HappiggyBank"
            return "http://itunes.apple.com/kr/lookup?bundleId=\(bundleID)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .lookUp:
            return .GET
        }
    }

    var headers: [String : String]? {
        switch self {
        case .lookUp:
            return nil
        }
    }

    var httpBody: Data? {
        switch self {
        case .lookUp:
            return nil
        }
    }
}
