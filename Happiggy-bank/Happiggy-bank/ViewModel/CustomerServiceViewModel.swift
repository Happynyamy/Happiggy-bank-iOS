//
//  CustomerServiceViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/20.
//

import MessageUI
import UIKit

/// 고객 지원 뷰 컨트롤러의 뷰모델
final class CustomerServiceViewModel {
    
    // MARK: - Enums
    
    // 셀별 내용
    private enum Content: Int, CaseIterable {
        
        /// 라이선스
        case license
        
        /// 메일
        case mail
        
        
        // MARK: - Properties
        
        /// 제목 딕셔너리
        static let title: [Int: String] = [
            license.rawValue: ContentTitle.license,
            mail.rawValue: ContentTitle.mail
        ]
    }
    
    
    // MARK: - Properties
    
    /// 섹션의 행 개수
    private(set) var numberOfRowsInSection = Content.allCases.count
    
    
    // MARK: - Functions
    
    /// 해당 칸의 제목 리턴
    func title(forContentAt indexPath: IndexPath) -> String? {
        Content.title[indexPath.row]
    }
    
    /// 내비게이션이 필요한 경우 내비게이션으로 넘어갈 뷰컨트롤러 리턴
    func destination(
        forContentAt indexPath: IndexPath,
        delegate: UIViewController
    ) -> UIViewController? {
        let storyboard = UIStoryboard(name: mainStoryboardName, bundle: .main)
        
        if indexPath.row == Content.license.rawValue {
            return storyboard.instantiateViewController(
                identifier: InformationTextViewController.name
            ) { coder in
                let viewModel = LicenseViewModel(navigationTitle: ContentTitle.license)
                
                return InformationTextViewController(coder: coder, viewModel: viewModel)
            }
        }
        
        if indexPath.row == Content.mail.rawValue {
            guard MFMailComposeViewController.canSendMail(),
                  let delegate = delegate as? MFMailComposeViewControllerDelegate
            else { return self.cannotSendMailAlert() }
            
            let mailViewController = MFMailComposeViewController().then {
                $0.mailComposeDelegate = delegate
                $0.setToRecipients([Mail.teamMail])
                $0.setSubject(Mail.subject)
                $0.setMessageBody(Mail.body, isHTML: true)
            }
            
            return mailViewController
        }
        
        return nil
    }
    
    /// 메일을 보낼 수 없을 때 나타낼 알림을 생성
    private func cannotSendMailAlert() -> UIAlertController {
        UIAlertController.basic(
            alertTitle: Mail.alertTitle,
            alertMessage: Mail.alertMessage,
            confirmAction: UIAlertAction.confirmAction()
        )
    }
}
