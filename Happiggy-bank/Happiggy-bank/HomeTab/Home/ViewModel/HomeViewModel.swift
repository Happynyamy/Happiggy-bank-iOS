//
//  HomeViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/19.
//

import UIKit
import CoreData

/// 데이터를 Home 뷰에 필요한 형식으로 변환해주는 뷰 모델
final class HomeViewModel {

    // MARK: - Properties
    /// 현재 저금통
    var bottle: Bottle?
    
    /// 현재 진행중인 저금통이 있는지 없는지에 대한 불리언 값
    var hasBottle: Bool {
        self.bottle != nil
    }
    
    /// 오늘이 개봉날인지 아닌지에 대한 불리언 값
    var isTodayEndDate: Bool {
        let today = Calendar.current.startOfDay(for: Date()).customFormatted(type: .dot)
        let endDate = self.bottle?.endDate.customFormatted(type: .dot)
        
        return today == endDate
    }
    
    /// 개봉날이 지났는지 아닌지에 대한 불리언 값
    var isEndDatePassed: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        guard let endDate = self.bottle?.endDate
        else { return false }
        
        return today > endDate
    }
    
    /// 쪽지가 있는지 없는지에 대한 불리언 값
    var hasNotes: Bool {
        guard let note = self.bottle?.notes
        else { return false }
        
        return !note.isEmpty
    }
    
    
    // MARK: - init
    init() {
        executeFetchRequest()
    }
    
    
    // MARK: - Functions
    
    /// 지난 저금통 리스트 가져오기
    func executeFetchRequest() {
        let request = Bottle.fetchRequest(isOpen: false)
        let bottles = PersistenceStore.shared.fetchOld(request: request)
        self.bottle = bottles.first
    }

    func dDay() -> String {
        var dDay: String = ""
        guard let endDate = bottle?.endDate
        else { return "" }
        let prefix = "D"
        let startDate = Date()
        let daysCount = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: endDate),
            to: Calendar.current.startOfDay(for: startDate)
        )
        guard let days = daysCount.day
        else { return "" }
        
        if days == 0 {
            dDay = prefix + "-" + "\(days)"
        } else if days > 0 {
            dDay = prefix + "+" + "\(days)"
        } else {
            dDay = prefix + "\(days)"
        }
        
        return dDay
    }

    
    /// 저금통의 현재 상태 스냅샷 생성
    func takeBottleSnapshot(inContainerView containerView: UIView) -> UIImage {
        
        let snapshotSize = Metric.snapshotSize(forView: containerView)
        
        /// 이미지 생성
        let renderer = UIGraphicsImageRenderer(size: containerView.bounds.size)
        let image = renderer.image { _ in
            containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: true)
        }
        
        /// 리사이징
        let resizedImageRenderer = UIGraphicsImageRenderer(size: snapshotSize)
        let resizedImage = resizedImageRenderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: snapshotSize))
        }
        
        return resizedImage
    }
}
