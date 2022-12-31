//
//  Version.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/31.
//

import Foundation

/// 1.1.1 형태의 버전
struct Version {

    // MARK: - Enums

    enum Status: Equatable, CustomStringConvertible {

        /// 초기화 상태 혹은 에러 등으로 설치된 버전을 나타내야 하는 상태
        case `default`

        /// 업데이트가 필요한 상태로 assoicated type을 통해 강제 여부를 표시
        case needsUpdate(shouldForceUpdate: Bool)

        /// 최신 버전을 사용중인 상태
        case latestVersion


        // MARK: - CustomStringConvertible

        var description: String {
            switch self {
            case .default:
                return Version.installed?.description ?? .empty
            case .needsUpdate:
                return "업데이트가 필요합니다."
            case .latestVersion:
                return "최신 버전입니다."
            }
        }
    }


    // MARK: - Properties

    /// 0.0.0
    static let zero = Version(major: .zero, minor: .zero, patch: .zero)

    /// 디바이스에 설치된 버전
    static let installed: Version? = {
        let infoDictionary = Bundle.main.infoDictionary
        let key = InfoDictionaryKey.CFBundleShortVersionString.rawValue
        let versionString = infoDictionary?[key] as? String

        return Version(string: versionString ?? .empty)
    }()

    let major: Int
    let minor: Int
    let patch: Int


    // MARK: - Inits

    init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// 숫자와 "."으로만 이루어진 문자열로부터 버전 정보를 추출하여 인스턴스를 생성, 형식이 일치하지 않는 경우 nil
    ///
    /// e.g. 1 -> 1.0.0 / 1.0 -> 1.0.0 / 1.0.0 -> 1.0.0 / 1.hi -> nil / 1#1#1 -> nil / version -> nil
    /// - Parameter string: 버전 정보를 담은 문자열
    init?(string: String) {
        let parsedInfo = string.split(separator: ".").map { Int(String($0)) }
        let versionInfo = parsedInfo.compactMap { $0 }

        guard parsedInfo.count == versionInfo.count,
              Metric.validRangeOfCountOfParsedNumbers ~= versionInfo.count
        else {
            return nil
        }

        self.major = versionInfo[0]
        self.minor = versionInfo[safe: 1] ?? .zero
        self.patch = versionInfo[safe: 2] ?? .zero
    }
}


// MARK: - CustomStringConvertible
extension Version: CustomStringConvertible {

    var description: String {
        "\(self.major).\(self.minor).\(self.patch)"
    }
}


// MARK: - Comparable
extension Version: Comparable {

    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }

        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }

        return lhs.patch < rhs.patch
    }
}


// MARK: - Constants
fileprivate extension Version {

    enum InfoDictionaryKey: String {
        case CFBundleShortVersionString
    }

    enum Metric {
        static let validRangeOfCountOfParsedNumbers = 1...3
    }
}
