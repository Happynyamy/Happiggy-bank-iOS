//
//  NotificationSettingViewController.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/03/31.
//

import UIKit
import UserNotifications

import Then

/// 노티피케이션 스위치 on/off에 따라 노티피케이션 추가/삭제하는 뷰 컨트롤러
final class NotificationSettingViewController: UIViewController {
    
    /// 알림 설정하는 스위치
    lazy var notificationControl: UISwitch = UISwitch().then {
        $0.isOn = UserDefaults.standard.bool(forKey: StringLiteral.hasNotificationOn)
        
    }
    
    /// 날짜 관련 데이터 처리해주는 뷰 모델
    private var viewModel: NotificationSettingViewModel = NotificationSettingViewModel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSwitch()
        configureSwitchConstraints()
    }
    
    
    // MARK: @objc functions
    
    /// 스위치에 변화가 있을 때 호출되는 objc 함수
    @objc func switchDidTap(_ sender: UISwitch) {
        if sender.isOn {
            requestNotification()
            scheduleNotifications()
            return
        }
        if !sender.isOn {
            removeNotifications()
            return
        }
    }
    
    
    // MARK: - Configure UI Components
    
    /// 스위치 설정
    private func configureSwitch() {
        self.notificationControl.addTarget(
            self,
            action: #selector(switchDidTap),
            for: .valueChanged
        )
        self.view.addSubview(notificationControl)
        UNUserNotificationCenter.current().requestAuthorization { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    self.notificationControl.isOn = false
                }
            }
        }
    }
    
    
    // MARK: - Notification related functions
    
    /// 노티피케이션 요청
    private func requestNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if !granted {
                UserDefaults.standard.set(false, forKey: StringLiteral.hasNotificationOn)
                DispatchQueue.main.async {
                    self.notificationControl.isOn = false
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
    
    /// 노티피케이션 스케줄링
    private func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized
            else { return }
            
            // 특정 기간동안 반복되는 알림 설정
            for day in 0...Metric.repeatingDays {
                let repeatingNotificationRequest = self.repeatingNotificationRequest(byAdding: day)
                center.add(repeatingNotificationRequest) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            UserDefaults.standard.set(true, forKey: StringLiteral.hasNotificationOn)
        }
    }
    
    /// 노티피케이션 리퀘스트 만들어주는 함수
    private func repeatingNotificationRequest(byAdding day: Int) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: self.viewModel.repeatingDateComponent(byAdding: day),
            repeats: false
        )
        content.title = StringLiteral.notificationTitle
        content.body = StringLiteral.notificationBody
        content.sound = .default
        
        return UNNotificationRequest(
            identifier: StringLiteral.notificationIdentifier + "\(day)",
            content: content,
            trigger: trigger
        )
    }
    
    /// 전달된, 대기중인 모든 노티피케이션 삭제
    private func removeNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        UserDefaults.standard.set(false, forKey: StringLiteral.hasNotificationOn)
    }
    
    
    // MARK: - Constraints
    
    /// 스위치 오토레이아웃 설정
    private func configureSwitchConstraints() {
        self.notificationControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.notificationControl.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            ),
            self.notificationControl.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor, constant: Metric.trailingPadding
            )
        ])
    }
}
