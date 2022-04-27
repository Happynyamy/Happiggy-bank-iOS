//
//  NotificationSettingViewModel.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/01.
//

import UIKit

/// 노티피케이션 관련 데이터 처리하는 뷰 모델
final class NotificationSettingViewModel {
    
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
}
