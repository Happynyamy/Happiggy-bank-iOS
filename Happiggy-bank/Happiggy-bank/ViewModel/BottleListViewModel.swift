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
    
    /// 현재 열고 있는 저금통을 나타내는 프로퍼티로 있다면 해당 저금통 엔티티, 없으면 nil
    var openingBottle: Bottle?
    
    /// 현재 열고 있는 저금통의 indexPath
    var openingBottleIndexPath: IndexPath? {
        guard let openingBottle = openingBottle,
              let row = self.bottleList.firstIndex(of: openingBottle)
        else { return nil }

        return IndexPath(row: row, section: .zero)
    }
    
    // MARK: - init
    init() {
        executeFetchRequest()
    }
    
    
    // MARK: - Functions
    
    // TODO: 확인용으로 주석처리된 foo 데이터 사용. 추후 삭제
    /// 지난 저금통 리스트 가져오기
    private func executeFetchRequest() {
        // guard let list = try? Bottle.fetchRequest(isOpen: true).execute()
        // else {
        //     self.bottleList = Array(repeating: Bottle.foo, count: 300)
//            self.bottleList = []
//            return
//        }
        
        let request = Bottle.fetchRequest(isOpen: true)
        var list = PersistenceStore.shared.fetch(request: request)
        
        if list.isEmpty {
            /// stock mock data
            list = Bottle.fooOpenBottles
            PersistenceStore.shared.save()
        }
//        PersistenceStore.shared.deleteAll(Bottle.self)
        
        self.bottleList = list
    }
}
