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
    
    /// 누르면 메일 앱을 띄우는 팀 소개 라벨
    @IBOutlet weak var teamLabel: UIStackView!
    
    
    // MARK: - Properties
    
    private var viewModel = SettingsViewModel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
        self.navigationItem.backButtonTitle = .empty
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
        
        if indexPath.row == Content.bottleAlert.rawValue {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsToggleButtonCell.name,
                for: indexPath
            ) as? SettingsToggleButtonCell
            else { return SettingsToggleButtonCell() }
            addNotificationSettingViewController(to: cell)
            return cell
        }
        
        if indexPath.row == Content.appVersion.rawValue ||
            indexPath.row == Content.customerService.rawValue {
            
            return self.labelButtonCell(
                inTableView: tableView,
                indexPath: indexPath,
                navigationButtonIsHidden: indexPath.row == Content.appVersion.rawValue
            )
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
    
    /// 라벨 버튼 셀 모습 설정
    private func labelButtonCell(
        inTableView tableView: UITableView,
        indexPath: IndexPath,
        navigationButtonIsHidden: Bool = false
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsLabelButtonCell.name,
            for: indexPath
        ) as? SettingsLabelButtonCell
        else { return SettingsLabelButtonCell() }
        
        cell.iconImageView.image = self.viewModel.icon(forContentAt: indexPath)
        cell.titleLabel.attributedText = self.viewModel.title(forContentAt: indexPath)
        cell.informationLabel.attributedText = self.viewModel.informationText(
            forContentAt: indexPath
        )
        cell.buttonImageView.isHidden = navigationButtonIsHidden
        
        return cell
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
}


// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let segueIdentifier = self.viewModel.segueIdentifier(forContentAt: indexPath)
        else { return }
        
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
        HapticManager.instance.selection()
    }
}
