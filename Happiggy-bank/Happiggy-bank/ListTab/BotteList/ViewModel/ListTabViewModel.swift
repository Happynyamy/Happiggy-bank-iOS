//
//  ListTabViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/17.
//

import Combine
import CoreData

/// ListTabView에서 사용하는 뷰모델
final class ListTabViewModel {
    
    // MARK: - Properties
    
    /// 지난 저금통 리스트
    var bottleList: [Bottle]?
    
    /// fetchedResultsController
    var controller: NSFetchedResultsController<Bottle> = PersistenceStore.shared.controller
    
    
    // MARK: - init
    
    init() {
        fetch()
    }
    
    
    // MARK: - Functions
    
    public func fetchAndPublish() -> AnyPublisher<[Bottle], Never>? {
        do {
            try self.controller.performFetch()
            self.bottleList = self.controller.fetchedObjects
            return self.bottleList.publisher.eraseToAnyPublisher()
        } catch {
            // TODO: Alert Error
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func fetch() {
        do {
            try self.controller.performFetch()
            self.bottleList = self.controller.fetchedObjects
        } catch {
            // TODO: Alert Error
            print(error.localizedDescription)
        }
    }
}
