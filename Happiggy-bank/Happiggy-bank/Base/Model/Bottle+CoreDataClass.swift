//
//  Bottle+CoreDataClass.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/07.
//
//

import CoreData
import UIKit

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
    
    
    // MARK: - Nil-coalesced Attributes
    
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
    
    /// 개봉 멘트
    var message: String {
        message_ ?? .empty
    }
    
    /// 이미지
    var image: UIImage {
        get { UIImage(data: image_ ?? Data()) ?? UIImage() }
        set { image_ = newValue.pngData() }
    }
    
    /// 해당 저금통에 들어있는 쪽지들의 배열
    /// 현재 작성 날짜순으로 정렬(가장 최신 쪽지가 맨 뒤)
    /// 정렬 방식 변경 시 isEmptyToday 변수도 바꿔줘야 함
    var notes: [Note] {
        guard let notes = self.notes_ as? Set<Note>
        else { return [] }
        
        return notes.map { $0 }.sorted { $0.date < $1.date }
    }
    
    
    // MARK: - Properties
    
    /// 저금통이 진행 중인지 혹은 종료 후 미개봉 상태인지 나타냄
    var isInProgress: Bool {
        return self.endDate > Date()
    }
    
    /// 저금 기간 (1주, 1개월, 3개월, 6개월, 1년)
    var duration: Int {
        Calendar.daysBetween(start: self.startDate, end: self.endDate) - 1
    }
    
    /// 오늘이 저금통 시작일을 포함해서 며칠째인지
    var numberOfDaysSinceStartDate: Int {
        let days = Calendar.daysBetween(start: self.startDate, end: Date())
        guard days > .zero
        else { return .zero }
        
        return days
    }
    
    /// 현재까지의 날짜 중에서 쪽지를 쓰지 않은 날짜가 있는지 나타냄
    var hasEmptyDate: Bool {
        guard self.numberOfDaysSinceStartDate != .zero
        else { return false }
        
        return self.numberOfDaysSinceStartDate > self.notes.count
    }
    
    /// 오늘 쪽지를 썼는지 여부
    var isEmtpyToday: Bool {
        guard Date() >= Calendar.current.startOfDay(for: self.startDate)
        else { return false }
        
        let noteToday = self.notes.reversed().first { Calendar.current.isDateInToday($0.date) }
        return (noteToday == nil) ? true : false
    }
    
    /// 시작 날짜부터 끝 날짜까지의 텍스트 라벨
    /// 22.02.05 ~ 22.02.05 형식
    var dateLabel: String {
        self.startDate.customFormatted(type: .abbreviatedDot)
        + StringLiteral.center
        + (Calendar.current.date(byAdding: .day, value: -1, to: self.endDate) ?? endDate)
            .customFormatted(type: .abbreviatedDot)
    }
}

// TODO: 목데이터 - 추후 삭제

enum FooBottleDuration: Int, CaseIterable {
    case week = 7
    case month = 30
    case threeMonths = 90
    case halfYear = 180
    case year = 365
}

extension Bottle {

    /// 모든 기간 저금통 배열
    static let fooOpenBottles = FooBottleDuration.allCases
        .shuffled()
        .enumerated()
        .map { fooOpened(duration: $0.element, openedNdaysBefore: UInt8($0.offset)) }

    /// 인자를 별도로 설정하지 않으면 하루 전이 종료일이었던 1년 짜리 저금통 리턴
    static func fooOpened(duration: FooBottleDuration = .year, openedNdaysBefore: UInt8 = 1) -> Bottle {
        let daysPassed = Int(openedNdaysBefore) + duration.rawValue
        let startDate = nthDayFromDate(value: -daysPassed)
        let endDate = Calendar.current.startOfDay(for: nthDayFromDate(startDate, value: duration.rawValue))

        let bottle = Bottle(
            title: "\(duration.rawValue) 가짜냠냠이🥸",
            startDate: startDate,
            endDate: endDate,
            message: "축 가짜 냠냠이 개봉🎉"
        )
        bottle.isOpen = true

        for index in 0..<duration.rawValue {
            Note.createRandomNote(for: bottle, date: nthDayFromDate(startDate, value: index))
        }

        return bottle
    }

    /// 인자를 별도로 설정하지 않으면 종료까지 이틀 남은 1년 짜리 저금통 리턴
    static func fooInProgress(duration: FooBottleDuration = .year, daysLeft: UInt8 = 2) -> Bottle {
        let daysLeft = 0..<duration.rawValue ~= Int(daysLeft) ? Int(daysLeft) : 2
        let daysPassed = duration.rawValue - daysLeft
        let startDate = nthDayFromDate(value: -daysPassed)
        let endDate = Calendar.current.startOfDay(for: nthDayFromDate(startDate, value: duration.rawValue))

        let bottle = Bottle(
            title: "가짜냠냠이🥸",
            startDate: startDate,
            endDate: endDate,
            message: "축 가짜 냠냠이 개봉🎉"
        )

        for index in 0..<daysPassed {
            Note.createRandomNote(for: bottle, date: nthDayFromDate(startDate, value: index))
        }

        return bottle
    }

    private static func nthDayFromDate(_ date: Date = Date(), value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: date)!
    }


    // MARK: - Old Version

    // swiftlint:disable line_length
    
    private static func makeMockData(duration: Int, isOpen: Bool = true) -> Bottle {
        let startDate = nthDayFromDate(value: -duration)
        let endDate = nthDayFromDate(value: -1)
        
        let bottle = Bottle(
            title: "행복냠냠이",
            startDate: startDate,
            endDate: endDate,
            message: "마지막 멘트"
        )
        bottle.isOpen = isOpen
        
        makeMockNote(inBottle: bottle, count: duration)
        
        return bottle
    }
    
    private static func makeMockNote(inBottle bottle: Bottle, count: Int) {
        for index in -count..<0 {
            Note.create(
                id: UUID(),
                date: nthDayFromDate(value: index),
                color: NoteColor.allCases.randomElement()!,
                content:
                    "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
                bottle: bottle
            )
        }
    }

    /// 테스트용 목 데이터
    static let foo: Bottle = {
        let count = 300
        let startDate = nthDayFromDate(value: -count)
        let endDate = nthDayFromDate(value: 5)
//        let endDate = nthDayFromToday(10)
        
        let bottle = Bottle(title: "행복냠냠이", startDate: startDate, endDate: endDate, message: "마지막멘트")
        
        // swiftlint:disable line_length
        Note.create(id: UUID(), date: startDate, color: NoteColor.green, content: "시작!", bottle: bottle)
        Note.create(id: UUID(), date: nthDayFromDate(value: -9), color: NoteColor.pink, content: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십", bottle: bottle)
        Note.create(id: UUID(), date: nthDayFromDate(value: -3), color: NoteColor.white, content: "100자 좀 적은가? 근데 괜찮은 것 같기도 하고...늘리기는 또 귀찮은데...", bottle: bottle)
        Note.create(id: UUID(), date: nthDayFromDate(value: -8), color: NoteColor.purple, content: "왜냐면 한줄만 쓰는 날도 백퍼 있을 것이기 때문", bottle: bottle)
        Note.create(id: UUID(), date: nthDayFromDate(value: -1), color: NoteColor.yellow, content: "졸리다 졸려 졸려", bottle: bottle)
        Note.create(id: UUID(), date: nthDayFromDate(value: 0), color: NoteColor.yellow, content: "누가 뚝딱 만들어주면 좋겠다 한 3줄 정도까지 채우고 싶은데 아무거나 써보기 이모지도 써보기 시험 시험 테스트 ☀️", bottle: bottle)
        for index in (10-count)..<(-10) {
            let note = Note.create(
                id: UUID(),
                date: nthDayFromDate(value: index),
                color: NoteColor.allCases.randomElement()!,
                content: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
                bottle: bottle)
        }
        // swiftlint:enable line_length
        return bottle
    }()
}
