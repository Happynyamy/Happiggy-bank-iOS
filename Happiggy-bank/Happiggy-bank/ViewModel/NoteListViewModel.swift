//
//  NoteListViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import CoreData
import UIKit

/// 쪽지에 필요한 형식으로 데이터를 변환해주는 뷰모델
final class NoteListViewModel {
    
    // MARK: - Properties
    
    /// 페이드인 여부
    var fadeIn: Bool = false
    
    /// 코어데이터로 불러온 쪽지 엔티티들을 관리하는 fetchedResultController
    lazy var fetchedResultController: NSFetchedResultsController<Note> = {
        let fetchRequest = Note.fetchRequest(bottle: self.bottle)
        
        let context = self.bottle.managedObjectContext ?? PersistenceStore.shared.context
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: bottle.id.uuidString
        )
        
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities")
        }
        
        return controller
    }()
    
    /// 쪽지 개수 라벨 문자열
    private(set) lazy var noteCountLabelString: String = {
        StringLiteral.noteCountLabelString(
            count: self.fetchedResultController.fetchedObjects?.count ?? .zero
        )
    }()
    
    /// 저금통 이름
    private(set) lazy var bottleTitle: String = {
        self.bottle.title
    }()
    
    /// 리스트에서 나타낼 저금통
    private var bottle: Bottle!
    
    /// FetchedResultsController 의 델리게이트 역할을 할 컨트롤러 : NoteListController
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    
    // MARK: - Init
    
    init(
        bottle: Bottle,
        fadeIn: Bool = false,
        fetchedResultContollerDelegate: NSFetchedResultsControllerDelegate?
    ) {
        self.bottle = bottle
        self.fadeIn = fadeIn
        self.fetchedResultsControllerDelegate = fetchedResultContollerDelegate
    }
    
}
