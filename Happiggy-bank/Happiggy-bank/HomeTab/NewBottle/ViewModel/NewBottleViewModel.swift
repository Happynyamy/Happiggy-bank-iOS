//
//  NewBottleViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/22.
//

import CoreData

/// Fetch시 발생하는 Error 타입
enum FetchError: Error {
    case invalidData
}

/// 새 저금통 생성 관련 비즈니스 로직 처리하는 뷰모델
final class NewBottleViewModel {
    lazy var controller: NSFetchedResultsController = PersistenceStore.shared.controller
    
    func createNewBottle(with data: NewBottle) -> Result<Bottle, Error> {
        guard let title = data.name,
              let endDate = data.endDate
        else { return .failure(FetchError.invalidData) }
        
        var bottle: Bottle
        
        if let openMessage = data.openMessage, !openMessage.isEmpty {
            bottle = Bottle(
                title: title,
                startDate: Date(),
                endDate: endDate,
                message: openMessage
            )
        } else {
            bottle = Bottle(
                title: title,
                startDate: Date(),
                endDate: endDate,
                message: Text.defaultMessage
            )
        }
        
        return .success(bottle)
    }
}

extension NewBottleViewModel {
    enum Text {
        
        /// 한마디 입력하지 않았을 시 자동으로 설정되는 디폴트 메시지
        static let defaultMessage: String = "반가워 내 행복들아!"
    }
}
