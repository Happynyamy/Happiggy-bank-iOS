//
//  NotificationSettingsViewController.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/03/31.
//

import UIKit
import UserNotifications

import Then

/// 노티피케이션(일일 알림, 리마인드 알림) 추가/삭제하는 뷰 컨트롤러
final class NotificationSettingsViewController: UIViewController {
    
    /// 노티피케이션 테이블 뷰
    @IBOutlet weak var tableView: UITableView!
    
    /// 날짜 관련 데이터 처리해주는 뷰 모델
    private var viewModel: NotificationSettingsViewModel = NotificationSettingsViewModel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.registerCells()
    }
    
    
    // MARK: - Functions
    
    /// 테이블 뷰 셀 등록
    private func registerCells() {
        self.tableView.register(
            UINib(nibName: NotificationToggleCell.name, bundle: nil),
            forCellReuseIdentifier: NotificationToggleCell.name
        )
    }
}

extension NotificationSettingsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.viewModel.contents.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationToggleCell.name,
            for: indexPath
        ) as? NotificationToggleCell
        else { return NotificationToggleCell() }
        
        // TODO: - 알림 관련 설정 정리
        cell.titleLabel.text = NotificationSettingsViewModel.Content.title[indexPath.row]
        cell.toggleButton.isOn = false
        
        return cell
    }
}
