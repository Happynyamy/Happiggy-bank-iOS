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
    
    /// 노티피케이션 요청
    private func requestNotification(of content: NotificationSettingsViewModel.Content) {
        self.viewModel.notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        ) { granted, error in
        
            if let error = error {
                print(error.localizedDescription)
            }
            
            if !granted {
                UserDefaults.standard.set(
                    false,
                    forKey: NotificationSettingsViewModel.Content.userDefaultsKey[content] ?? ""
                )
                DispatchQueue.main.async {
                    self.alertDisabledState()
                }
            }
        }
    }
    
    /// 설정에서 알림 꺼져있을 때 나타내는 알림창
    private func alertDisabledState() {
        let alert = UIAlertController(
            title: StringLiteral.disabledAlertTitle,
            message: StringLiteral.disabledAlertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: StringLiteral.move,
                style: .default
            ) { _ in
                self.openSettings()
            }
        )
        alert.addAction(
            UIAlertAction(
                title: StringLiteral.cancel,
                style: .cancel
            )
        )
        
        self.present(alert, animated: true)
    }
    
    /// 설정으로 이동
    private func openSettings() {
        if let bundle = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
    }
}

extension NotificationSettingsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return NotificationSettingsViewModel.Content.allCases.count
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
        
        // TODO: - Daily Noti에 TimePicker 추가 및 설정
        if indexPath.row == NotificationSettingsViewModel.Content.daily.rawValue {
            self.viewModel.configureDailyNotificationCell(cell.toggleButton)
        }
        
        if indexPath.row == NotificationSettingsViewModel.Content.reminder.rawValue {
            self.viewModel.configureRemindNotificationCell(cell.toggleButton)
        }
        
        return cell
    }
}
