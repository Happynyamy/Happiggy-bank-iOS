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
            $0.predicate = NSPredicate(format: "isOpen == %@", argumentArray: [isOpen])
            $0.sortDescriptors = sortDescriptor
        }
    }
    
    
    // MARK: - Init(s)
    
    /// 주어진 제목, 시작날짜, 종료날짜를 갖는 저금통 인스턴스를 코어데이터에 새로 생성함
    /// 아이디는 자체 생성, isOpen 과 hasFixedTitle 은 기본 false 로 설정
    /// 저장은 별도로 해야함
    convenience init(title: String, startDate: Date, endDate: Date, message: String) {
        self.init(context: PersistenceStore.shared.context)
        self.id_ = UUID()
        self.title_ = title
        self.startDate_ = startDate
        self.endDate_ = endDate
        self.message_ = message
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
    
    var message: String {
        message_ ?? .empty
    }
    
    /// 해당 저금통에 들어있는 쪽지들의 배열
    var notes: [Note] {
        guard let notes = self.notes_ as? Set<Note>
        else { return [] }
        
        return notes.map { $0 }.sorted { $0.date < $1.date }
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
    
    /// 오늘 쪽지를 썼는지 여부
    var isEmtpyToday: Bool {
        guard let mostRecentNote = self.notes.last?.date
        else { return true }

        return !Calendar.current.isDateInToday(mostRecentNote)
    }
    
    /// 시작 날짜부터 끝 날짜까지의 텍스트 라벨
    /// 2022.02.05 ~ 2022.02.05 형식
    var dateLabel: String {
        self.startDate.customFormatted(type: .spaceAndDot)
        + StringLiteral.center
        + self.endDate.customFormatted(type: .spaceAndDot)
    }
}

// TODO: 목데이터 - 추후 삭제
extension Bottle {
    
    // swiftlint:disable line_length
    private static func nthDayFromToday(_ value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: Date())!
    }
    
    private static func makeMockData(duration: Int, isOpen: Bool = true) -> Bottle {
        let startDate = nthDayFromToday(-duration)
        let endDate = nthDayFromToday(-1)
        
        let bottle = Bottle(
            title: "행복냠냠이",
            startDate: startDate,
            endDate: endDate,
            message: "안녕"
        )
        bottle.isOpen = isOpen
        
        makeMockNote(inBottle: bottle, count: duration)
        
        return bottle
    }
    
    private static func makeMockNote(inBottle bottle: Bottle, count: Int) {
        for index in -count..<0 {
            Note.create(
                date: nthDayFromToday(index),
                color: NoteColor.allCases.randomElement()!,
                content:
                    "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
                bottle: bottle
            )
        }
    }
    
    static let fooOpenBottles: [Bottle] = {
        var bottles = [Bottle]()
        
        for duration in [365, 180, 90, 30, 7] {
            bottles.append(makeMockData(duration: duration))
        }
        
        return bottles
    }()
    
    /// 테스트용 목 데이터
    static let foo: Bottle = {
        let count = 355 - 2
        let startDate = nthDayFromToday(-count)
        let endDate = nthDayFromToday(9)
        
        let bottle = Bottle(title: "행복냠냠이", startDate: startDate, endDate: endDate, message: "안녕")
        for index in 5..<count {
            let note = Note.create(
                date: nthDayFromToday(-index-1),
                color: NoteColor.allCases.randomElement()!,
                content: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
                bottle: bottle)
        }
//        Note.create(date: startDate, color: NoteColor.green, content: "시작!", bottle: bottle)
//        Note.create(date: nthDayFromToday(-9), color: NoteColor.pink, content: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십", bottle: bottle)
//        Note.create(date: nthDayFromToday(-3), color: NoteColor.white, content: "100자 좀 적은가? 근데 괜찮은 것 같기도 하고...늘리기는 또 귀찮은데...", bottle: bottle)
//        Note.create(date: nthDayFromToday(-8), color: NoteColor.purple, content: "왜냐면 한줄만 쓰는 날도 백퍼 있을 것이기 때문", bottle: bottle)
//        Note.create(date: nthDayFromToday(-1), color: NoteColor.yellow, content: "졸리다 졸려 졸려", bottle: bottle)
        // MARK: - 오늘 이미 작성한 상태 테스트하려면 아래 주석 해제
//        Note.create(date: Date(), color: NoteColor.yellow, content: "누가 뚝딱 만들어주면 좋겠다 한 3줄 정도까지 채우고 싶은데 아무거나 써보기 이모지도 써보기 시험 시험 테스트 ☀️", bottle: bottle)
        
        return bottle
    }()
    
    static let fullBottle: Bottle = {
        var count = 365
//        count = 180
//        count = 90
//        count = 30
//        count = 7
        
        let noteCount = count
        
        let startDate = nthDayFromToday(-count)
        let endDate = nthDayFromToday(-1)
        
        let bottle = Bottle(title: "행복냠냠이", startDate: startDate, endDate: endDate,
                            message: "안녕")
        for index in 0..<noteCount {
            let note = Note.create(
                date: nthDayFromToday(-index-1),
                color: NoteColor.allCases.randomElement()!,
                content: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
                bottle: bottle)
        }
        return bottle
    }()
}
// swiftlint:enable line_length
