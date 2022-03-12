//
//  Bottle+CoreDataClass.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/07.
//
//

import CoreData
import Foundation

import Then

@objc(Bottle)
/// 코어데이터의 저금통 엔티티
public class Bottle: NSManagedObject {

    // MARK: - Static functions
    
    /// sortDescriptor 를 설정하지 않으면 (생성 날짜) 최신순으로 정렬
    static func fetchRequest(
        predicate: NSPredicate,
        sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(
            key: "startDate_",
            ascending: false
        )]
    ) -> NSFetchRequest<Bottle> {
        NSFetchRequest<Bottle>(entityName: Bottle.name).then {
            $0.predicate = predicate
            $0.sortDescriptors = sortDescriptor
        }
    }
    
    /// 개봉/미개봉된 저금통을 각각 불러올 수 있으며 sortDescriptor 를 설정하지 않으면 (생성 날짜) 최신순으로 정렬
    /// 홈뷰 -> 미개봉 저금통
    /// 저금통 리스트 -> 개봉 저금통
    static func fetchRequest(
        isOpen: Bool,
        sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(
            key: "startDate_",
            ascending: false
        )]
    ) -> NSFetchRequest<Bottle> {
        NSFetchRequest<Bottle>(entityName: Bottle.name).then {
            $0.sortDescriptors = sortDescriptor
            $0.predicate = NSPredicate(format: "isOpen_ == %@", argumentArray: [isOpen])
            $0.sortDescriptors = sortDescriptor
        }
    }
    
    
    // MARK: - Init(s)
    
    /// 주어진 제목, 시작날짜, 종료날짜를 갖는 저금통 인스턴스를 코어데이터에 새로 생성함
    /// 아이디는 자체 생성, isOpen 과 hasFixedTitle 은 기본 false 로 설정
    /// 저장은 별도로 해야함
    convenience init(title: String, startDate: Date, endDate: Date) {
        self.init(context: PersistenceStore.shared.context)
        self.id_ = UUID()
        self.title_ = title
        self.startDate_ = startDate
        self.endDate_ = endDate
    }
    
    
    // MARK: - (nil-coalesced) Properties
    
    /// 고유 아이디
    public var id: UUID { id_ ?? UUID() }
    
    /// 제목
    var title: String {
        get { title_ ?? StringLiteral.title}
        set { title_ = newValue }
    }
    
    /// 시작 날짜
    var startDate: Date {
        startDate_ ?? Date()
    }
    
    /// 개봉 예정 날짜
    var endDate: Date {
        endDate_ ?? Date()
    }
    
    /// 해당 저금통에 들어있는 쪽지들의 Set
    var notes: Set<Note> {
        notes_ as? Set<Note> ?? []
    }
    
    // TODO: 유저가 앱을 켜놓은 상태에서 기한이 지나면?
    /// 저금통이 진행 중인지 혹은 종료 후 미개봉 상태인지 나타냄
    var isInProgress: Bool {
        return self.endDate > Date()
    }
    
    /// 저금 기간 (1주, 1개월, 3개월, 6개월, 1년)
    var duration: Int {
        Calendar.daysBetween(start: self.startDate, end: self.endDate)
    }
    
    /// 오늘이 저금통 시작일을 포함해서 며칠째인지
    var numberOfDaysSinceStartDate: Int {
        Calendar.daysBetween(start: self.startDate, end: Date())
    }
    
    /// 현재까지의 날짜 중에서 쪽지를 쓰지 않은 날짜가 있는지 나타냄
    var hasEmptyDate: Bool {
        self.numberOfDaysSinceStartDate > self.notes.count
    }
}

extension Bottle {
    
    private static func nthDayFromToday(_ value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: Date())!
    }
    
    /// 테스트용 목 데이터
    static let foo: Bottle = {
        
        let startDate = nthDayFromToday(-10)
        let endDate = nthDayFromToday(10)
        
        let bottle = Bottle(title: "행복냠냠이", startDate: startDate, endDate: endDate)
        
        Note.create(date: startDate, color: NoteColor.green, content: "시작!", bottle: bottle)
        Note.create(date: nthDayFromToday(-9), color: NoteColor.pink, content: "둘째!", bottle: bottle)
        Note.create(date: nthDayFromToday(-3), color: NoteColor.white, content: "셋째!", bottle: bottle)
        Note.create(date: nthDayFromToday(-8), color: NoteColor.purple, content: "넷째!", bottle: bottle)
        Note.create(date: nthDayFromToday(-1), color: NoteColor.yellow, content: "다섯째!", bottle: bottle)
        Note.create(date: nthDayFromToday(0), color: NoteColor.yellow, content: "여섯째!", bottle: bottle)
        
        return bottle
    }()
}
