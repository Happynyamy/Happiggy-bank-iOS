//
//  SettingsViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/22.
//

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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == Content.bottleAlertSettings.rawValue {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsToggleButtonCell.name,
                for: indexPath
            ) as? SettingsToggleButtonCell
            else { return SettingsToggleButtonCell() }
            
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
}
