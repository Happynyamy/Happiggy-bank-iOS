//
//  NotificationSettingViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/08/01.
//

import UserNotifications

final class NotificationSettingViewModel {
    
    /// UserNotificationCenter
    let notificationCenter = UNUserNotificationCenter.current()
    
    /// UserDefaults
    private let userDefaults = UserDefaults.standard
    
    /// 저금통이 끝나는 날짜
    lazy var endDate: Date? = {
        let request = Bottle.fetchRequest(isOpen: false)
        let bottles = PersistenceStore.shared.fetchOld(request: request)
        guard let bottle = bottles.first
        else { return nil }
        return bottle.endDate
    }()
    
    /// 일일 알림이 설정된 시간
    lazy var dailyNotificationTime: Date? = UserDefaults.standard.object(
        forKey: Content.datePickerUserDefaultsKey
    ) as? Date
    
    /// 리마인드 알림을 설정할 수 있는지 없는지 판단하는 Bool값
    lazy var canUpdateRemindNotification: Bool? = {
        return self.endDate != nil
    }()
    
    
    // MARK: - Function
    
    /// 토글 버튼의 활성화 여부
    func shouldToggleButtonOn(of content: Content) -> Bool {
        return userDefaults.bool(forKey: content.userDefaultsKey)
    }
    
    /// 타임피커 숨겨야 하는지 여부
    func shouldHideTimePicker(of content: Content) -> Bool {
        switch content {
        case .daily:
            return !shouldToggleButtonOn(of: content)
        case .reminder:
            return true
        }
    }
    
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
    func scheduleNotifications(of content: Content) {
        
        fetchBottleEndDate()
        
        self.notificationCenter.getNotificationSettings { [weak self] settings in
            guard let self = self
            else { return }
            
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
            
            self.userDefaults.set(true, forKey: content.userDefaultsKey)
            self.userDefaults.set(self.dailyNotificationTime, forKey: Content.datePickerUserDefaultsKey)
        }
    }
    
    /// 전달된, 대기중인 모든 노티피케이션 삭제
    func removeNotifications(of content: Content) {
        switch content {
        case .daily:
            self.notificationCenter.removeDeliveredNotifications(
                withIdentifiers: [content.notificationIdentifier]
            )
            self.notificationCenter.removePendingNotificationRequests(
                withIdentifiers: [content.notificationIdentifier]
            )
        case .reminder:
            if self.endDate == nil { break }
            for day in 0...Metric.repeatingDays {
                self.notificationCenter.removeDeliveredNotifications(
                    withIdentifiers: [content.notificationIdentifier + "\(day)"]
                )
                self.notificationCenter.removePendingNotificationRequests(
                    withIdentifiers: [content.notificationIdentifier + "\(day)"]
                )
            }
        }
        userDefaults.set(false, forKey: content.userDefaultsKey)
    }
    
    private func fetchBottleEndDate() {
        let request = Bottle.fetchRequest(isOpen: false)
        let bottles = PersistenceStore.shared.fetchOld(request: request)
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
        content.title = Content.daily.message.title
        content.body = Content.daily.message.body
        content.sound = .default
        
        return UNNotificationRequest(
            identifier: Content.daily.notificationIdentifier,
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
        content.title = Content.reminder.message.title
        content.body = Content.reminder.message.body
        content.sound = .default
        
        return UNNotificationRequest(
            identifier: Content.reminder.notificationIdentifier + "\(day)",
            content: content,
            trigger: trigger
        )
    }
    
    // MARK: Function for Debug Notifications
    
    /// pending, delivered된 노티피케이션 출력하는 유틸리티 함수
    fileprivate func printNotifications() {
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

extension NotificationSettingViewModel {
    
    /// 상수값
    enum Metric {
        
        /// 노티피케이션 반복할 날짜
        static let repeatingDays: Int = 3
    }

    /// 각 셀 별 내용
    enum Content: Int, CaseIterable {
        /// 일일 알림 설정
        case daily
        /// 리마인드 알림 설정
        case reminder
        
        /// 노티피케이션 시간을 저장하는 userDefaults 데이터의 key
        static let datePickerUserDefaultsKey: String = "timePickerDate"
        
        /// 제목
        internal var title: String {
            switch self {
            case .daily:
                return "일일 알림"
            case .reminder:
                return "리마인드 알림"
            }
        }
        
        /// userDefault key
        internal var userDefaultsKey: String {
            switch self {
            case .daily:
                return "dailyNotification"
            case .reminder:
                return "remindNotification"
            }
        }
        
        /// NotificationCenter의 식별자
        internal var notificationIdentifier: String {
            switch self {
            case .daily:
                return "dailyNotification"
            case .reminder:
                return "remindNotification"
            }
        }
        
        /// Alert에 대한 title과 body
        internal var message: (title: String, body: String) {
            switch self {
            case .daily:
                return ("오늘의 기분은?", "오늘 느낀 행복을 저장해보세요 :)")
            case .reminder:
                return ("행복한 소식!", "저금통을 열어볼 준비가 되었어요 :)")
            }
        }
    }
}
