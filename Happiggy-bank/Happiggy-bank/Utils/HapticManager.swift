//
//  HapticManager.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/13.
//

import UIKit

/// 햅틱 반응을 위한 클래스
class HapticManager {
    
    /// 햅틱 매니저 인스턴스
    static let instance = HapticManager()
    
    /// 타입(.success, .warning, .failure)에 따른 햅틱 반응
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
