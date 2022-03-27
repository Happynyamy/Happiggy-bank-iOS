//
//  HomeViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/19.
//

import UIKit

/// 데이터를 Home 뷰에 필요한 형식으로 변환해주는 뷰 모델
final class HomeViewModel {

    // MARK: - Properties
    /// 현재 저금통
    var bottle: Bottle?
    
    /// 현재 진행중인 저금통이 있는지 없는지에 대한 불리언 값
    var hasBottle: Bool {
        self.bottle != nil
    }
    
    
    // MARK: - init
    init() {
        executeFetchRequest()
    }
    
    
    // MARK: - Functions
    
    // TODO: 확인용으로 주석처리된 foo 데이터 사용. 추후 삭제
    /// 지난 저금통 리스트 가져오기
    func executeFetchRequest() {
//        guard let bottle = try? Bottle.fetchRequest(isOpen: false).execute()
//        else {
//            self.hasBottle = false
//            return
//        }
//
//        self.bottle = bottle.first!
        
//        let request = Bottle.fetchRequest(isOpen: false)
//        var bottles = PersistenceStore.shared.fetch(request: request)
//
//        // MARK: 작성중인 유리병을 확인하려면 여기를 주석 해제
//        // 1. 여기 먼저 주석 해제해서 delete 으로 데이터 한번 날리고
////                PersistenceStore.shared.deleteAll(Bottle.self)
//        // 2. 그 다음에 delete 은 다시 주석처리하고 여리를 주석 해제
//        if bottles.isEmpty {
//            // 작성중인 유리병
//            bottles = [Bottle.foo]
////            PersistenceStore.shared.save()
//        }
//
//        self.bottle = bottles.first
        
        self.bottle = Bottle.foo
//        self.bottle = Bottle.fullBottle
    }
}
