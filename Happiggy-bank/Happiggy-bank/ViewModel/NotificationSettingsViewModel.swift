//
//  NotificationSettingsViewModel.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/01.
//

import UIKit

/// 노티피케이션 관련 데이터 처리하는 뷰 모델
final class NotificationSettingsViewModel {
    
    /// UserNotificationCenter
    let notificationCenter = UNUserNotificationCenter.current()
    
    /// Notification Content의 allCases
    let content = NotificationSettingsViewModel.Content.allCases
    
    /// 저금통이 끝나는 날짜
    lazy var endDate: Date? = {
        let request = Bottle.fetchRequest(isOpen: false)
        let bottles = PersistenceStore.shared.fetch(request: request)
        guard let bottle = bottles.first
        else { return nil }
        return bottle.endDate
    }()

    
    // MARK: - @objc functions
    
    /// 일일 알림 토글 버튼에 변화가 있을 때 호출되는 objc 함수
    @objc private func dailyNotificationToggleButtonDidTap(_ sender: UISwitch) {
        if sender.isOn {
            // TODO: request Notification and Alert
            scheduleNotifications(of: .daily)
            return
        }
        if !sender.isOn {
            removeNotifications(of: .daily)
            return
        }
    }
    
    /// 리마인드 알림 토글 버튼에 변화가 있을 때 호출되는 objc 함수
    @objc private func remindNotificationToggleButtonDidTap(_ sender: UISwitch) {
        if sender.isOn {
            // TODO: request Notification and Alert
            scheduleNotifications(of: .reminder)
            return
        }
        
        if !sender.isOn {
            removeNotifications(of: .reminder)
            return
        }
    }
    
    
    // MARK: - Functions
    
    /// day만큼 반복되는 DateComponents 만드는 함수
    func repeatingDateComponent(byAdding day: Int) -> DateComponents {
        if let endDate = endDate,
           let repeatingDate = Calendar.current.date(
            byAdding: DateComponents(day: day),
            to: endDate
        ) {
            return Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: repeatingDate
            )
        }
        return DateComponents()
    }
    
    
    // MARK: - Configure Cell with UIComponents
    
    // TODO: TimePicker 설정 해야함
    /// 일일 알림 셀 설정
    func configureDailyNotificationCell(_ button: UISwitch) {
        button.addTarget(
            self,
            action: #selector(dailyNotificationToggleButtonDidTap),
            for: .valueChanged
        )
        
        self.notificationCenter.requestAuthorization { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    button.isOn = false
                }
            }
        }
    }
    
    /// 리마인드 알림 셀 설정
    func configureRemindNotificationCell(_ button: UISwitch) {
        button.addTarget(
            self,
            action: #selector(remindNotificationToggleButtonDidTap),
            for: .valueChanged
        )
        
        self.notificationCenter.requestAuthorization { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    button.isOn = false
                }
            }
        }
    }
    
    /// 노티피케이션 스케줄링
    private func scheduleNotifications(of content: NotificationSettingsViewModel.Content) {
        
        self.notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized
            else { return }
            
            switch content {
            case .daily:
                let request = self.notificationRequest()
                self.notificationCenter.add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            case .reminder:
                for day in 0...Metric.repeatingDays {
                    let request = self.notificationRequest(byAdding: day)
                    self.notificationCenter.add(request) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
            UserDefaults.standard.set(
                true,
                forKey: NotificationSettingsViewModel.Content.userDefaultsKey[content] ?? ""
            )
        }
    }
    
    /// 전달된, 대기중인 모든 노티피케이션 삭제
    private func removeNotifications(of content: NotificationSettingsViewModel.Content) {
        switch content {
        case .daily:
            self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [
                StringLiteral.notificationIdentifier
            ])
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [
                StringLiteral.notificationIdentifier
            ])
        case .reminder:
            for day in 0...Metric.repeatingDays {
                self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [
                    StringLiteral.notificationIdentifier + "\(day)"
                ])
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [
                    StringLiteral.notificationIdentifier + "\(day)"
                ])
            }
        }
        UserDefaults.standard.set(
            false,
            forKey: NotificationSettingsViewModel.Content.userDefaultsKey[content] ?? ""
        )
    }
    
    /// 일일 알림 리퀘스트 만들어주는 함수
    private func notificationRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day], from: Date()),
            repeats: true
        )
        content.title = NotificationSettingsViewModel.Content.message[.daily]?.first ?? ""
        content.body = NotificationSettingsViewModel.Content.message[.daily]?.last ?? ""
        content.sound = .default
        
        return UNNotificationRequest(
            identifier: StringLiteral.notificationIdentifier,
            content: content,
            trigger: trigger
        )
    }
    
    /// 리마인드 알림 리퀘스트 만들어주는 함수
    private func notificationRequest(byAdding day: Int) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: self.repeatingDateComponent(byAdding: day),
            repeats: false
        )
        content.title = NotificationSettingsViewModel.Content.message[.reminder]?.first ?? ""
        content.body = NotificationSettingsViewModel.Content.message[.reminder]?.last ?? ""
        content.sound = .default
        
        return UNNotificationRequest(
            identifier: StringLiteral.notificationIdentifier + "\(day)",
            content: content,
            trigger: trigger
        )
    }
}
