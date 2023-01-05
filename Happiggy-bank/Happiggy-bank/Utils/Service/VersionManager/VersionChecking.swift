//
//  VersionChecking.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/13.
//

import Foundation

/// 최신 버전과 설치된 버전을 비교하여 상태를 파악하고 상태가 변경될 때마다 발행함
protocol VersionChecking: Publisher where Value == Version.Status {

    // MARK: - Properteis

    /// 설치된 버전의 상태
    var status: Version.Status { get }


    // MARK: - Functions

    /// 앱스토어에서 앱의 최신 버전을 받아와 설치된 버전과 비교하여 현재 버전의 상태를 체크
    func fetchVersionStatus() async
}
