//
//  SettingsViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/06.
//

import UIKit

/// 환경설정 뷰 컨트롤러의 뷰모델
final class SettingsViewModel {

    // MARK: - Enums

    /// 환경설정 각 행의 종류
    enum RowType: Int, CaseIterable {

        /// 알림 설정
        case alert

        /// 버전 정보
        case version

        /// 폰트 설정
        case font

        /// 고객 지원
        case customerService


        // MARK: - Properties

        fileprivate var icon: UIImage? {
            switch self {
            case .alert:
                return AssetImage.alert
            case .version:
                return AssetImage.version
            case .font:
                return AssetImage.font
            case .customerService:
                return AssetImage.customerService
            }
        }

        fileprivate var title: String {
            switch self {
            case .alert:
                return "알림 설정"
            case .version:
                return "버전 정보"
            case .font:
                return "폰트 바꾸기"
            case .customerService:
                return "고객 지원"
            }
        }

        fileprivate var buttonImage: UIImage? {
            AssetImage.next
        }
    }


    // MARK: - Properties

    let versionManager: any VersionChecking
    let fontManager: FontManaging

    var numberOfRows: Int {
        RowType.allCases.count
    }


    // MARK: - Inits

    init(versionManager: any VersionChecking, fontManager: FontManaging) {
        self.versionManager = versionManager
        self.fontManager = fontManager
    }


    // MARK: - Cell Content Functions

    func rowType(for indexPath: IndexPath) -> RowType? {
        RowType(rawValue: indexPath.row)
    }

    func icon(for indexPath: IndexPath) -> UIImage? {
        RowType(rawValue: indexPath.row)?.icon
    }

    func title(for indexPath: IndexPath) -> String? {
        RowType(rawValue: indexPath.row)?.title
    }

    func buttonTitle(for indexPath: IndexPath) -> String? {
        guard let type = RowType(rawValue: indexPath.row)
        else {
            return nil
        }

        switch type {
        case .version:
            return self.versionManager.status.description
        case .font:
            return self.fontManager.font.description
        default:
            return nil
        }
    }

    func buttonImage(for indexPath: IndexPath) -> UIImage? {
        let type = RowType(rawValue: indexPath.row)
        guard type == .version
        else {
            return type?.buttonImage
        }

        switch self.versionManager.status {
        case .latestVersion, .default:
            return nil
        default:
            return type?.buttonImage
        }
    }

    func buttonTitleColor(for indexPath: IndexPath) -> UIColor? {
        let type = RowType(rawValue: indexPath.row)
        guard type == .version
        else {
            return .label
        }

        return AssetColor.mainGreen
    }
}
