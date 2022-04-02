//
//  HapticManager.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/13.
//

import UIKit

/// 햅틱 반응을 위한 클래스
final class HapticManager {
    
    /// 햅틱 매니저 인스턴스
    static let instance = HapticManager()
    
    /// 타입(.success, .warning, .failure)에 따른 햅틱 반응
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// 유저의 선택에 따라 UI 요소가 변화하고 있을 때 사용하는 햅틱 반응
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
