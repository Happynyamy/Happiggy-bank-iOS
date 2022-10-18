//
//  NotificationSettingsViewModel.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/01.
//

import UIKit

/// 노티피케이션 관련 데이터 처리하는 뷰 모델
final class NotificationSettingsViewModel {
    
    let contents = NotificationSettingsViewModel.Content.allCases
    
    lazy var bottle: Bottle = {
        let request = Bottle.fetchRequest(isOpen: false)
        let bottles = PersistenceStore.shared.fetch(request: request)
        guard let bottle = bottles.first
        else { return Bottle() }
        return bottle
    }()
    
    func repeatingDateComponent(byAdding day: Int) -> DateComponents {
        let endDate = bottle.endDate
        if let repeatingDate = Calendar.current.date(
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
        
//        self.present(alert, animated: true)
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
            dateMatching: self.repeatingDateComponent(byAdding: day),
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
    
    
    //    // MARK: - @objc functions
    //
    //    /// 스위치에 변화가 있을 때 호출되는 objc 함수
    //    @objc func switchDidTap(_ sender: UISwitch) {
    //        if sender.isOn {
    //            requestNotification()
    //            scheduleNotifications()
    //            return
    //        }
    //        if !sender.isOn {
    //            removeNotifications()
    //            return
    //        }
    //    }
        
        
    //    // MARK: - Configure UI Components
    //
    //    /// 스위치 설정
    //    private func configureSwitch() {
    //        self.notificationControl.addTarget(
    //            self,
    //            action: #selector(switchDidTap),
    //            for: .valueChanged
    //        )
    //        self.view.addSubview(notificationControl)
    //        UNUserNotificationCenter.current().requestAuthorization { granted, _ in
    //            if !granted {
    //                DispatchQueue.main.async {
    //                    self.notificationControl.isOn = false
    //                }
    //            }
    //        }
    //    }
}
