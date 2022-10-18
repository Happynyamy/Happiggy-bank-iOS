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
        self.configureNavigationBar()
        self.addObservers()
    }
    
    
    // MARK: - @objc
    
    /// 커스텀 폰트 변화 시 변경 사항을 필요한 하위 뷰에 적용
    @objc private func customFontDidChange(_ notification: Notification) {
        
        guard let customFont = notification.object as? CustomFont
        else { return }
        
        self.updateAllFontUsingViews(customFont)
        self.updateFontSelectionCellFontName(to: customFont)
    }
    
    /// 백그라운드에서 포어그라운드로 돌아올 때 버전 셀 업데이트
    @objc private func updateVersionCell() {
        
        let indexPath = IndexPath(row: Content.appVersion.rawValue, section: .zero)
        guard let versionCell = self.tableView.cellForRow(
                at: indexPath
              ) as? SettingsLabelButtonCell
        else { return }
        
        versionCell.informationLabel.attributedText = self.viewModel.informationText(
            forContentAt: indexPath
        )
        versionCell.buttonImageView.isHidden = (VersionManager.shared.needsUpdate != .true)
    }
    
    
    // MARK: - Functions
    
    /// 테이블 뷰 셀 등록
    private func registerCells() {
        self.tableView.register(
            UINib(nibName: SettingsLabelButtonCell.name, bundle: nil),
            forCellReuseIdentifier: SettingsLabelButtonCell.name
        )
    }
    
    /// 내비게이션 바 초기 설정
    private func configureNavigationBar() {
        self.navigationItem.backButtonTitle = .empty
        self.navigationController?.navigationBar.clear()
    }
    
    /// 폰트 변경 시 현재 폰트 이름으로 폰트 선택 셀의 정보 라벨 텍스트 업데이트
    private func updateFontSelectionCellFontName(to customFont: CustomFont) {
        let indexPath = IndexPath(row: Content.fontSelection.rawValue, section: .zero)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? SettingsLabelButtonCell
        else { return }
        
        cell.informationLabel.text = customFont.displayName
    }
    
    /// 옵저버들 추가
    private func addObservers() {
        self.observeCustomFontChange(selector: #selector(customFontDidChange(_:)))
        self.observe(selector: #selector(self.updateVersionCell), name: .appStoreInfoDidLoad)
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
        
        if indexPath.row == Content.appVersion.rawValue {
            return self.labelButtonCell(
                inTableView: tableView,
                indexPath: indexPath,
                navigationButtonIsHidden: VersionManager.shared.needsUpdate != .true
            )
        }
            
        return self.labelButtonCell(
            inTableView: tableView,
            indexPath: indexPath,
            navigationButtonIsHidden: false
        )
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
        
        if indexPath.row == Content.appVersion.rawValue,
           VersionManager.shared.needsUpdate == .true {
            return self.openAppStore()
        }
        
        guard let segueIdentifier = self.viewModel.segueIdentifier(forContentAt: indexPath)
        else { return }
        
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
        HapticManager.instance.selection()
    }
}
