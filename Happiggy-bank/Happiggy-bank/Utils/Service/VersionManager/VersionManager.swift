//
//  VersionManager.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/13.
//

import UIKit

/// 앱 버전 업데이트 정보를 관리
final class VersionManager: VersionChecking {
    typealias Status = Version.Status

    // MARK: - Properties

    private(set) lazy var status = Status.default

    private let networkManager: NetworkServiceable

    /// Status 변화 시 알려야 할 객체들
    private var subscribers = [Subscriber<Status>]()
    
    
    // MARK: - Inits

    init(networkManager: NetworkServiceable) {
        self.networkManager = networkManager
    }


    // MARK: - Publisher Functions

    func addSubscriber(_ subscriber: AnyObject, handler: @escaping (Status) -> Void) {
        self.subscribers.append(Subscriber(subscriber, handler: handler))
    }

    func removeSubscriber(_ subscriber: AnyObject) {
        self.subscribers.removeAll { $0.object === subscriber }
    }

    private func notifyAllSubscribers(status: Status) {
        self.subscribers.forEach { $0.handler(status) }
    }

    
    // MARK: - VersionChecking Functions

    func fetchVersionStatus() async {
        let endpoint = AppStoreEndpoint.lookUp
        let lookUpResult: LookUpResult? = try? await self.networkManager.resume(for: endpoint)
        self.status = self.defineStatus(using: lookUpResult)
        self.notifyAllSubscribers(status: self.status)
    }

    private func defineStatus(using lookUpResult: LookUpResult?) -> Status {
        guard let appStoreVersionInfo = lookUpResult?.results.first,
              let latestVersion = Version(string: appStoreVersionInfo.version),
              let installedVersion = Version.installed
        else {
            return .default
        }

        guard installedVersion < latestVersion
        else {
            return .latestVersion
        }

        let releaseNotes = appStoreVersionInfo.releaseNotes
        let minimumRequiredVersion = self.parseMinimumRequiredVersion(from: releaseNotes) ?? .zero
        let shouldForceUpdate = installedVersion < minimumRequiredVersion

        return .needsUpdate(shouldForceUpdate: shouldForceUpdate)
    }

    /// 최소 지원 버전을 파싱
    ///
    /// **최소 지원 버전이 생기는 경우 반드시 해당 버전부터 이후의 모든 배포 시 릴리즈 노트 맨 하단에 d.d.d 형태(e.g. 1.0.0)로 명시해야 함**
    /// - Parameter releaseNotes: 릴리즈 노트 문자열
    /// - Returns: 최소 지원 버전이 있는 경우 Version, 없는 경우 nil
    private func parseMinimumRequiredVersion(from releaseNotes: String) -> Version? {
        guard let versionString = releaseNotes.substringsMatchingRegex(StringLiteral.versionRegex).last
        else {
            return nil
        }

        return Version(string: versionString)
    }
}


// MARK: - Constants
fileprivate extension VersionManager {
    
    enum StringLiteral {
        static let versionRegex = "\\d+.\\d+.\\d+"
    }
}
