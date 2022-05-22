//
//  LookUpResult.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/20.
//

import Foundation

/// 앱스토어에서 가져온 앱 정보
struct AppStoreVersionInfo: Decodable {
    /// 배포중인  버전
    var version: String
    
    /// 앱 릴리즈 노트
    var releaseNotes: String
    
    /// 다운로드 url
    var trackViewUrl: String
}


/// 앱스토어에서 가져온 앱 정보 배열
struct LookUpResult: Decodable {
    /// 결과 배열
    var results: [AppStoreVersionInfo]
}
