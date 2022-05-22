//
//  UIViewController+VersionUpdating.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/22.
//

import UIKit

extension UIViewController: VersionUpdating {
    
    // MARK: - Enums
    
    private enum StringLiteral {
        /// 알림 제목
        static let appStoreOpenErrorAlertTitle = "앱스토어를 열 수 없습니다."
        static let appStoreOpenErrorAlertMessage = "앱스토어에서 행복저금통을 직접 업데이트 해 주세요."
    }
    
    
    // MARK: - Properties
    
    /// 강제 업데이트 알림
    private var forceUpdateAlert: UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(title: "업데이트") { _ in
            VersionManager.shared.forceUpdateAlertIsPresented.toggle()
            self.openAppStore()
        }
        
        return UIAlertController.basic(
            alertTitle: "필수 업데이트가 있습니다",
            confirmAction: confirmAction
        )
    }
    
    /// 강제 업데이트 오류 시 앱 종료를 확인하는 알림
    private var closeAppAlert: UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(title: "앱 종료", style: .default) { _ in
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
    func openAppStore() {
        guard let urlString = VersionManager.shared.appStoreVersionInfo?.trackViewUrl,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url)
        else {
            let alertController = (VersionManager.shared.needsForcedUpdate) ?
            self.closeAppAlert : self.selfUpdateAlert
            return self.present(alertController, animated: true)
        }
        
        url.open()
    }
    
    /// 강제 업데이트가 필요하고, 아직 알림이 띄워지지 않은 경우 알림을 띄우는 메서드
    func presentForceUpdateAlertIfNeeded() {
        guard !VersionManager.shared.forceUpdateAlertIsPresented
        else { return }
        
        VersionManager.shared.forceUpdateAlertIsPresented.toggle()
        self.present(self.forceUpdateAlert, animated: true)
    }
}
