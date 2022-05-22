//
//  URL+AppStore.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/20.
//

import Foundation

extension URL {
    
    /// 앱스토어 URL
    enum AppStore {
        /// 앱스토어 앱 정보 url
        static let appInfo = URL(string: StringLiteral.appInfo)
    }
}
