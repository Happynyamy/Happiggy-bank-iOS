//
//  PersistenceStore.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/08.
//

import CoreData
import UIKit

import Then

/// 싱글턴 패턴을 사용해 앱 전체에서 하나의 Persistence Container 를 통해 엔티티 인스턴스를  저장, 삭제하도록 함
final class PersistenceStore {
    
    // MARK: - Core Data Stack
    
    /// 앱 전체에서 공유되는 단일 PersistenceStore
    static var shared: PersistenceStore = {
        PersistenceStore(name: StringLiteral.sharedPersistenceStoreName)
    }()
    
    static private(set) var fatalErrorDescription: String?
    
    /// persistence container 의 viewContext 에 접근하기 위한 syntactic sugar
    private(set) lazy var context: NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()
    
    private let persistentContainer: NSPersistentContainer
    
    weak var windowScene: UIWindowScene?
    
    /// FetchedResultsController
    lazy var controller: NSFetchedResultsController<Bottle> = {
        let request = Bottle.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "startDate_",
            ascending: false
        )]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return controller
    }()
    
    
    // MARK: - Init(s)
    private init(name: String) {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        self.persistentContainer = NSPersistentContainer(name: name).then {
            $0.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    PersistenceStore.fatalErrorDescription = """
                    \(error.localizedDescription)
                    \(error.userInfo)
                """
                    print(error.localizedDescription)
                    print(error.userInfo)
                }
            }
        }
    }
    
    
    // MARK: - Core Data Fetching support

    // TODO: 리팩토링 완료 후 삭제
    /// 코어데이터를 불러오기 위한 syntactic sugar
    func fetchOld<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let items = try self.context.fetch(request)
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    /// 성공 시 [T]의 형태로 배열 리턴, 실패 시 에러 리턴
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> Result<[T], Error> {
        do {
            let items = try self.context.fetch(request)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
    
    
    // MARK: - Core Data Saving support

    // TODO: 리팩토링 완료 후 삭제
    /// 현재 context 를 저장, 에러가 발생하면 발생한 에러 메시지(기본은 에러 이름)를 출력함
    @discardableResult
    func saveOld() -> (String, String)? {
        if self.context.hasChanges {
            do {
                try self.context.save()
                return nil

            } catch {
                let nserror = error as NSError

                let title = StringLiteral.saveErrorTitle
                let message = """
\(StringLiteral.saveErrorMessage)
\(nserror.localizedDescription)
\(nserror.localizedFailureReason ?? .empty)
\(nserror.userInfo)
"""
                return (title, message)
            }
        }
        return nil
    }

    /// 변화가 없거나 저장에 성공하면 리턴값이 없고, 저장 실패 시 에러 리턴
    @discardableResult
    func save() -> Result<Void, Error> {
        guard self.context.hasChanges
        else {
            return .success(())
        }

        do {
            try self.context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    
    // MARK: - Core Data Deleting support
    /// TODO: 개발 단계 편의를 위한 메서드로 추후 삭제
    
    /// 엔티티 인스턴스 삭제
    func delete(_ object: NSManagedObject) {
        self.context.delete(object)
    }
    
    /// 엔티티의 모든 인스턴스 삭제
    func deleteAll<T: NSManagedObject>(_ type: T.Type) -> Result<Void, Error> {
        let request = type.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(delete)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    
    // MARK: - Alert

    // TODO: 리팩토링 완료 후 삭제
    /// 알림
    func makeErrorAlert(
        title: String?,
        message: String?,
        confirmHandler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        
        let confirmAction = UIAlertAction.confirmAction(
            title: StringLiteral.okButtonTitle,
            handler: confirmHandler
        )
        
        return UIAlertController.basic(
            alertTitle: title,
            alertMessage: message,
            confirmAction: confirmAction
        )
    }
}
