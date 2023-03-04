//
//  NotePreviewListViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import CoreData
import UIKit

/// 쪽지에 필요한 형식으로 데이터를 변환해주는 뷰모델
final class NotePreviewListViewModel {

    // MARK: - Properties

    /// 저금통 이름
    let bottleTitle: String

    /// 페이드인 여부
    var fadeIn: Bool = false

    /// FetchedResultsController 의 델리게이트 역할을 할 컨트롤러 : NotePreviewListController
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    var notes: [Note] { self.fetchedResultController.fetchedObjects ?? [] }

    /// 리스트에서 나타낼 저금통
    private var bottle: Bottle

    /// 코어데이터로 불러온 쪽지 엔티티들을 관리하는 fetchedResultController
    private lazy var fetchedResultController: NSFetchedResultsController<Note> = {
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
            // FIXME: - 제거...
            fatalError("Failed to fetch entities")
        }

        return controller
    }()

    
    // MARK: - Init
    
    init(bottle: Bottle, fadeIn: Bool = false) {
        self.bottle = bottle
        self.bottleTitle = self.bottle.title
        self.fadeIn = fadeIn
    }
    
    
    // MARK: - Functions

    func note(at indexPath: IndexPath) -> Note {
        self.fetchedResultController.object(at: indexPath)
    }
    
    /// 태그 셀의 배경 색깔 리턴
    func backgroundColor(for color: NoteColor) -> UIColor? {
        color != .white ? AssetColor.noteBG(for: color) : AssetColor.noteWhiteBG2List
    }
    
    /// 첫 단어를 색깔 변환한 문자열
    func attributedFirstWordString(forNote note: Note) -> NSMutableAttributedString {
        note.firstWord
            .nsMutableAttributedStringify()
            .color(color: AssetColor.noteText(for: note.color) ?? .white)
    }
}
