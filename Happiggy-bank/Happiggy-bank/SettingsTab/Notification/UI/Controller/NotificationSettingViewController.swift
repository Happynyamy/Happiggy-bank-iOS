//
//  NotificationSettingViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/07/26.
//

import UIKit

import SnapKit
import Then

final class NotificationSettingViewController: UIViewController {
    
    private var viewModel = NotificationSettingViewModel()
    
    private let tableView = UITableView().then {
        $0.rowHeight = Metric.rowHeight
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
    }
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerCells()
        configureNavigationBar()
    }
    
    
    // MARK: - @objc functions
    
    /// 알림 토글 버튼에 변화가 있을 때 호출되는 objc 함수
    @objc private func toggleButtonDidTap(_ sender: UISwitch) {
        let indexPath = [IndexPath(row: sender.tag, section: 0)]
        let content = NotificationSettingViewModel.Content.allCases[sender.tag]
        
        if sender.isOn {
            requestNotification(of: content) {
                self.viewModel.scheduleNotifications(of: content)
                DispatchQueue.main.async {
                    if content == .reminder && self.viewModel.canUpdateRemindNotification == false {
                        self.notificationSettingDisabledAlert(of: content)
                    }
                    self.tableView.reloadRows(at: indexPath, with: .automatic)
                }
            }
            return
        }
        if !sender.isOn {
            viewModel.removeNotifications(of: content)
            tableView.reloadRows(at: indexPath, with: .automatic)
        }
    }
    
    // MARK: - 시간 설정하는 데이트피커가 일일 알림 외에 다른 알림에도 붙을 때 코드 수정 필요
    /// 시간을 설정하는 데이트피커에 변화가 있을 때 호출되는 objc 함수
    @objc private func timePickerDidChanged(_ sender: UIDatePicker) {
        let indexPath = [IndexPath(row: sender.tag, section: 0)]
        
        viewModel.dailyNotificationTime = sender.date
        viewModel.removeNotifications(of: .daily)
        viewModel.scheduleNotifications(of: .daily)
        
        UserDefaults.standard.set(
            sender.date,
            forKey: NotificationSettingViewModel.Content.datePickerUserDefaultsKey
        )
        tableView.reloadRows(at: indexPath, with: .automatic)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(
            NotificationSettingTableViewCell.self,
            forCellReuseIdentifier: NotificationSettingTableViewCell.name
        )
    }
    
    private func configureNavigationBar() {
        self.navigationItem.backButtonTitle = .empty
        self.navigationController?.navigationBar.clear()
        self.navigationItem.title = StringLiteral.navigationTitle
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
    private func requestNotification(
        of content: NotificationSettingViewModel.Content,
        _ completionHandler: @escaping () -> Void
    ) {
        self.viewModel.notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        ) { granted, error in
        
            if let error = error {
                print(error.localizedDescription)
            }
            
            if !granted {
                UserDefaults.standard.set(false, forKey: content.userDefaultsKey)
                DispatchQueue.main.async {
                    self.notificationSettingDisabledAlert(of: content)
                }
            } else {
                UserDefaults.standard.set(true, forKey: content.userDefaultsKey)
            }
            
            completionHandler()
        }
    }
    
    /// 설정에서 알림 꺼져있을 때 나타내는 알림창
    private func notificationSettingDisabledAlert(
        of content: NotificationSettingViewModel.Content
    ) {
        var alertTitle: String
        var alertMessage: String
        var action: UIAlertAction
        
        switch content {
        case .daily:
            alertTitle = StringLiteral.disabledAlertTitle
            alertMessage = StringLiteral.disabledAlertMessage
            action = UIAlertAction(
                title: StringLiteral.moveToSettings,
                style: .default
            ) { _ in
                self.openSettings()
            }
        case .reminder:
            alertTitle = StringLiteral.reminderDisabledAlertTitle
            alertMessage = StringLiteral.reminderDisabledAlertMessage
            action = UIAlertAction(
                title: StringLiteral.moveToHome,
                style: .default
            ) { _ in
                self.moveToHomeView()
            }
        }
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(action)
        self.present(alert, animated: false)
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
    
    /// 홈 화면으로 이동
    private func moveToHomeView() {
        self.tabBarController?.selectedIndex = 0
    }
}

extension NotificationSettingViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        NotificationSettingViewModel.Content.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationSettingTableViewCell.name,
            for: indexPath
        ) as? NotificationSettingTableViewCell ?? NotificationSettingTableViewCell()
        let index = indexPath.row
        let allCases = NotificationSettingViewModel.Content.allCases
        
        clearCellBeforeReuse(cell)
        
        cell.titleLabel.text = allCases[index].title
        cell.timePicker.isHidden = viewModel.shouldHideTimePicker(of: allCases[index])
        cell.toggleButton.isOn = viewModel.shouldToggleButtonOn(of: allCases[index])
        cell.timePicker.tag = index
        cell.toggleButton.tag = index
        
        configureNotificationCellActions(of: index, cell.toggleButton, cell.timePicker)
        
        return cell
    }
    
    
    // MARK: - Configure Cell
    
    private func clearCellBeforeReuse(_ cell: NotificationSettingTableViewCell) {
        cell.titleLabel.text = .empty
        cell.timePicker.isHidden = true
        cell.toggleButton.isOn = false
        cell.toggleButton.tag = 0
    }
    
    private func configureNotificationCellActions(
        of index: Int,
        _ button: UISwitch,
        _ timePicker: UIDatePicker
    ) {
        
        button.addTarget(self, action: #selector(toggleButtonDidTap), for: .valueChanged)
        
        switch NotificationSettingViewModel.Content.allCases[index] {
        case .daily:
            timePicker.addTarget(self, action: #selector(timePickerDidChanged), for: .valueChanged)
            
            viewModel.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized
                else {
                    DispatchQueue.main.async {
                        button.isOn = false
                        timePicker.isHidden = true
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    button.isOn = self.viewModel.shouldToggleButtonOn(of: .daily)
                    timePicker.isHidden = self.viewModel.shouldHideTimePicker(of: .daily)
                    timePicker.date = UserDefaults.standard.object(
                        forKey: NotificationSettingViewModel.Content.datePickerUserDefaultsKey
                    ) as? Date ?? Date()
                }
            }
        case .reminder:
            viewModel.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized,
                      self.viewModel.endDate != nil,
                      self.viewModel.canUpdateRemindNotification != false
                else {
                    DispatchQueue.main.async {
                        button.isOn = false
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    button.isOn = self.viewModel.shouldToggleButtonOn(of: .reminder)
                }
            }
        }
    }
}

extension NotificationSettingViewController {
    
    enum Metric {
        static let rowHeight: CGFloat = 67
    }
    
    enum StringLiteral {
        /// 내비게이션 타이틀
        static let navigationTitle = "알림 설정"
        
        /// 알림 타이틀
        static let disabledAlertTitle: String = "알림을 허용해주세요."
        
        /// 알림 메시지
        static let disabledAlertMessage: String = "알림을 받으려면 시스템 설정에서 행복저금통 알림을 허용해주세요."
        
        /// 알림 이동 액션 라벨
        static let moveToSettings: String = "설정으로 이동"
        
        /// 알림 취소 액션 라벨
        static let cancel: String = "취소"
        
        /// 리마인드 알림 불가시 알림 타이틀
        static let reminderDisabledAlertTitle: String = "저금통이 없어요!"
        
        /// 리마인드 알림 불가시 알림 메시지
        static let reminderDisabledAlertMessage: String = "리마인드 알림을 받으려면 저금통을 생성해주세요."
        
        /// 홈 화면으로 이동
        static let moveToHome: String = "만들러 가기"
    }
}
