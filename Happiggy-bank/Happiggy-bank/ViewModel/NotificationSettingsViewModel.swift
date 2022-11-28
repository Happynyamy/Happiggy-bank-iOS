//
//  NotificationSettingsViewModel.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/01.
//

import UserNotifications

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
    
    /// 일일 알림이 설정된 시간
    lazy var dailyNotificationTime: Date? = UserDefaults.standard.object(
        forKey: StringLiteral.datePickerUserDefaultsKey
    ) as? Date
    
    /// 리마인드 알림을 설정할 수 있는지 없는지 판단하는 Bool값
    lazy var canUpdateRemindNotification: Bool? = {
        return self.endDate != nil
    }()
    
    
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
    
    /// 노티피케이션 스케줄링
    func scheduleNotifications(of content: NotificationSettingsViewModel.Content) {
        
        fetchBottleEndDate()
        
        self.notificationCenter.getNotificationSettings { settings in
            switch content {
            case .daily:
                guard settings.authorizationStatus == .authorized
                else { return }
                let request = self.notificationRequest(at: self.dailyNotificationTime)
                self.notificationCenter.add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            case .reminder:
                guard settings.authorizationStatus == .authorized,
                      self.endDate != nil
                else {
                    self.canUpdateRemindNotification = false
                    return
                }
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
            UserDefaults.standard.set(
                self.dailyNotificationTime,
                forKey: StringLiteral.datePickerUserDefaultsKey
            )
        }
    }
    
    /// 전달된, 대기중인 모든 노티피케이션 삭제
    func removeNotifications(of content: NotificationSettingsViewModel.Content) {
        switch content {
        case .daily:
            self.notificationCenter.removeDeliveredNotifications(
                withIdentifiers: [StringLiteral.notificationIdentifier]
            )
            self.notificationCenter.removePendingNotificationRequests(
                withIdentifiers: [StringLiteral.notificationIdentifier]
            )
        case .reminder:
            if self.endDate == nil { break }
            for day in 0...Metric.repeatingDays {
                self.notificationCenter.removeDeliveredNotifications(
                    withIdentifiers: [StringLiteral.notificationIdentifier + "\(day)"]
                )
                self.notificationCenter.removePendingNotificationRequests(
                    withIdentifiers: [StringLiteral.notificationIdentifier + "\(day)"]
                )
            }
        }
        UserDefaults.standard.set(
            false,
            forKey: NotificationSettingsViewModel.Content.userDefaultsKey[content] ?? ""
        )
    }
    
    private func fetchBottleEndDate() {
        let request = Bottle.fetchRequest(isOpen: false)
        let bottles = PersistenceStore.shared.fetch(request: request)
        guard let bottle = bottles.first
        else {
            self.canUpdateRemindNotification = false
            return
        }
        
        self.endDate = bottle.endDate
        self.canUpdateRemindNotification = nil
    }
    
    /// 일일 알림 리퀘스트 만들어주는 함수
    private func notificationRequest(at time: Date?) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.hour, .minute],
                from: time == nil ? Date() : time!
            ),
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
    
    // MARK: Function for Debug Notifications
    
    /// pending, delivered된 노티피케이션 출력하는 유틸리티 함수
    private func printNotifications() {
        self.notificationCenter.getPendingNotificationRequests { requests in
            print("++++pending requests++++")
            print(requests)
            print("-----------------------")
        }
        self.notificationCenter.getDeliveredNotifications { notifications in
            print("****delivered notifications****")
            print(notifications)
            print("-------------------------------")
        }
    }
}
