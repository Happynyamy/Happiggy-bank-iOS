//
//  SettingsViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/22.
//

import MessageUI
import UIKit

/// 환경 설정 뷰 컨트롤러
final class SettingsViewController: UIViewController {

    // MARK: - @IBOutlets
    
    /// 환경 설정 각 항목을 담고 있는 테이블 뷰
    @IBOutlet weak var tableView: UITableView!
    
    /// 누르면 깃헙 레포로 넘어가는 팀 소개 라벨
    @IBOutlet weak var teamLabel: UIStackView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
    }
    
    
    // MARK: - @IBActions
    
    /// 팀 라벨이 탭 되었을 때 호출되는 메서드
    @IBAction func teamLabelDidTap(_ sender: UITapGestureRecognizer) {
        self.presentMailApp()
    }
    
    
    // MARK: - Functions
    
    /// 테이블 뷰 셀 등록
    private func registerCells() {
        self.tableView.register(
            UINib(nibName: SettingsLabelButtonCell.name, bundle: nil),
            forCellReuseIdentifier: SettingsLabelButtonCell.name
        )
        self.tableView.register(
            UINib(nibName: SettingsToggleButtonCell.name, bundle: nil),
            forCellReuseIdentifier: SettingsToggleButtonCell.name
        )
    }
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Content.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if indexPath.row == Content.bottleAlertSettings.rawValue {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsToggleButtonCell.name,
                for: indexPath
            ) as? SettingsToggleButtonCell
            else { return SettingsToggleButtonCell() }
            addNotificationSettingViewController(to: cell)
            return cell
        }
        
        if indexPath.row == Content.appVersionInformation.rawValue {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsLabelButtonCell.name,
                for: indexPath
            ) as? SettingsLabelButtonCell
            else { return SettingsLabelButtonCell() }
            
            return cell
        }
        
        return SettingsViewCell()
    }
    
    /// 노티피케이션 셀에 뷰 컨트롤러 추가
    private func addNotificationSettingViewController(to cell: SettingsToggleButtonCell) {
        let viewController = NotificationSettingViewController()
        self.addChild(viewController)
        cell.contentView.addSubview(viewController.view)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(
                equalTo: cell.contentView.leadingAnchor
            ),
            viewController.view.trailingAnchor.constraint(
                equalTo: cell.contentView.trailingAnchor
            ),
            viewController.view.topAnchor.constraint(
                equalTo: cell.contentView.topAnchor
            ),
            viewController.view.bottomAnchor.constraint(
                equalTo: cell.contentView.bottomAnchor
            )
        ])
    }
}


// MARK: - MFMailComposeViewControllerDelegate
/// 메일 관련 메서드, 프로퍼티
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
    
    /// 메일 앱을 모달 뷰로 띄우는 메서드
    private func presentMailApp() {
        guard MFMailComposeViewController.canSendMail()
        else { return }
        
        let mailViewController = MFMailComposeViewController().then {
            $0.mailComposeDelegate = self
            $0.setToRecipients(Mail.recipients)
            $0.setSubject(Mail.subject)
            $0.setMessageBody(Mail.body, isHTML: true)
        }
        // TODO: add haptic selection feedback
        present(mailViewController, animated: true)
    }
}
