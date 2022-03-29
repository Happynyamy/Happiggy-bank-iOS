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
class PersistenceStore {
    
    // MARK: - Core Data Stack
    
    /// 앱 전체에서 공유되는 단일 PersistenceStore
    static var shared: PersistenceStore = {
        PersistenceStore(name: StringLiteral.sharedPersistenceStoreName)
    }()
    
    /// persistence container 의 viewContext 에 접근하기 위한 syntactic sugar
    private(set) lazy var context: NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()
    
    private let persistentContainer: NSPersistentContainer
    
    
    // MARK: - Init(s)
    private init(name: String) {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        self.persistentContainer = NSPersistentContainer(name: name).then {
            
            // MARK: 시뮬레이터/디바이스마다 해당 코드 돌려주시고 지워주세요...! 54줄까지 지워주시면 됩니다...!
            let datamodelName = StringLiteral.sharedPersistenceStoreName
            let storeType = "sqlite"
            let url: URL = {
                let url = FileManager.default.urls(
                    for: .applicationSupportDirectory,
                       in: .userDomainMask
                )[0].appendingPathComponent("\(datamodelName).\(storeType)")
                
                assert(FileManager.default.fileExists(atPath: url.path))

                return url
            }()
            try? $0.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: storeType, options: nil)
            
            $0.loadPersistentStores(completionHandler: { _, error in
                if let error = error as NSError? {
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate.
                    // You should not use this function in a shipping application,
                    // although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible,
                     * due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        }
    }
    
    
    // MARK: - Core Data Fetching support
    
    /// 코어데이터를 불러오기 위한 syntactic sugar
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let items = try self.context.fetch(request)
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    // MARK: - Core Data Saving support
    
    /// 현재 context 를 저장, 에러가 발생하면 설정한 에러 메시지(기본은 에러 이름)를 출력함
    func save(errorMessage: String? = nil) {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nserror = error as NSError
                if let errorMessage = errorMessage {
                    print("\(errorMessage)+\(nserror.localizedDescription)+\(nserror.userInfo)")
                } else {
                    print("\(nserror.localizedDescription), \(nserror.userInfo)")
                }
            }
        }
    }
    
    
    // MARK: - Core Data Deleting support
    /// TODO: 개발 단계 편의를 위한 메서드로 추후 삭제
    
    /// 엔티티 인스턴스 삭제
    func delete(_ object: NSManagedObject) {
        self.context.delete(object)
        self.save()
    }
    
    /// 엔티티의 모든 인스턴스 삭제
    func deleteAll<T: NSManagedObject>(_ type: T.Type) {
        let request = type.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
}
