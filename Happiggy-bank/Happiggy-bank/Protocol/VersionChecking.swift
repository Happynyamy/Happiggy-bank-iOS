//
//  VersionChecking.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/13.
//

import Foundation

/// 앱 설치된 버전, 앱스토어 최신 버전 확인 기능
protocol VersionChecking {
    
    // MARK: - Properties
    
    /// 업데이트 필요 여부
    var needsUpdate: OptionalBool { get }
    
    /// 강제 업데이트 필요 여부
    var needsForcedUpdate: Bool { get }
    
    /// 설치된 버전
    var installedVersion: String? { get }
    
    /// 최신 버전
    var latestVersion: String? { get }
    
    /// 앱스토어 앱 버전 확인 후 필요한 작업을 수행
    func checkVersionOnAppStore(completionHandler: ((Bool) -> Void)?)
}
