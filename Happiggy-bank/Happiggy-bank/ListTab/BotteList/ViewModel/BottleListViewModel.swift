//
//  BottleListViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/17.
//

import CoreData

/// Bottle List View Model
final class BottleListViewModel {
    
    // MARK: - Properties
    /// 지난 저금통 리스트
    var bottleList: [Bottle]!
    
    
    // MARK: - init
    init() {
        executeFetchRequest()
    }
    
    
    // MARK: - Functions
    
    // TODO: 확인용으로 주석처리된 foo 데이터 사용. 추후 삭제
    /// 지난 저금통 리스트 가져오기
    func executeFetchRequest() {
//        let request = Bottle.fetchRequest(isOpen: true)
//        let list = PersistenceStore.shared.fetchOld(request: request)
        self.bottleList = Bottle.fooOpenBottles
    }
}
