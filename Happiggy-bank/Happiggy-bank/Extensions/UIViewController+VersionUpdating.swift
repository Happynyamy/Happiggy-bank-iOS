//
//  UIViewController+VersionUpdating.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/22.
//

import UIKit

extension UIViewController {

    // MARK: - Enums

    private enum StringLiteral {
        static let appStoreDownloadURL =
        "https://apps.apple.com/kr/app/%ED%96%89%EB%B3%B5%EC%A0%80%EA%B8%88%ED%86%B5/id1618732744"

        static let appStoreOpenErrorAlertTitle = "앱스토어를 열 수 없습니다."
        static let appStoreOpenErrorAlertMessage = "앱스토어에서 행복저금통을 직접 업데이트 해 주세요."

        static let forcedUpdateAlertTitle = "필수 업데이트가 있습니다"
        static let forcedUpdateAlertConfirmActionTitle = "업데이트"

        static let closeAppConfirmActionTitle = "앱 종료"
    }


    // MARK: - Properties

    /// 강제 업데이트 알림
    private var forcedUpdateAlert: UIAlertController {
        let confirmActionTitle = StringLiteral.forcedUpdateAlertConfirmActionTitle
        let confirmAction = UIAlertAction.confirmAction(title: confirmActionTitle) { [weak self] _ in
            self?.openAppStore { [weak self] didOpen in
                guard !didOpen,
                      let closeAppAlert = self?.closeAppAlert
                else {
                    return
                }

                self?.present(closeAppAlert, animated: true)
            }
        }

        return UIAlertController.basic(
            alertTitle: StringLiteral.forcedUpdateAlertTitle,
            confirmAction: confirmAction
        )
    }

    /// 강제 업데이트 오류 시 앱 종료를 확인하는 알림
    private var closeAppAlert: UIAlertController {
        let confirmActionTitle = StringLiteral.closeAppConfirmActionTitle
        let confirmAction = UIAlertAction.confirmAction(title: confirmActionTitle, style: .default) { _ in
            exit(.zero)
        }

        return UIAlertController.basic(
            alertTitle: StringLiteral.appStoreOpenErrorAlertTitle,
            alertMessage: StringLiteral.appStoreOpenErrorAlertMessage,
            confirmAction: confirmAction
        )
    }

    /// 앱스토어를 열 수 없을 때 나타나는 알림
    private var selfUpdateAlert: UIAlertController {
        UIAlertController.basic(
            alertTitle: StringLiteral.appStoreOpenErrorAlertTitle,
            alertMessage: StringLiteral.appStoreOpenErrorAlertMessage,
            confirmAction: UIAlertAction.confirmAction()
        )
    }


    // MARK: - Functions

    /// 앱스토어를 여는 메서드
    func openAppStore(completionHandler: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: StringLiteral.appStoreDownloadURL),
              UIApplication.shared.canOpenURL(url)
        else {
            completionHandler?(false)
            return
        }

        url.open(completionHandler: completionHandler)
    }

    /// 강제 업데이트 알림을 띄움
    func presentForcedUpdateAlert() {
        self.present(self.forcedUpdateAlert, animated: true)
    }
}
