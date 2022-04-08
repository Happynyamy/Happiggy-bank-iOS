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
    var notes: [Note] {
        guard let notes = self.notes_ as? Set<Note>
        else { return [] }
        
        return notes.map { $0 }.sorted { $0.date < $1.date }
    }

    
    // MARK: - Properties
    
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
                content: randomContent,
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
        let offset = 0
        let count = 365 - offset
        let startDate = nthDayFromToday(-count)
        let endDate = nthDayFromToday(-1 + offset)
        
        let bottle = Bottle(title: "행복냠냠이", startDate: startDate, endDate: endDate, message: "안녕")
        for index in 0+offset..<count {
            let note = Note.create(
                date: nthDayFromToday(-index-1),
                color: NoteColor.allCases.randomElement()!,
                content: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
                bottle: bottle)
        }
        
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
                content: randomContent,
                bottle: bottle)
        }
        return bottle
    }()


    static var randomContent: String {
        let content = rawData
        .components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        .shuffled()
        .joined(separator: " ")
        .prefix(100)
        
        return String(content)
        
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate let rawData = """
       \n\n   발맞춰 어디론가 run away
    (Yeah) 건조한 사막이라도 okay
    (Yeah) 구름은 햇빛의 우산이 돼\n
    Oh I'm not alone
    하루하루 눈을 뜨고 나면 새로움 투성이
    거울 속에 나는 나를 만나
    새로운나를꽃피워
    시간은 단지 그리면 돼 (그리면 돼)
    정해진 건 하나 없는 (Yeah, yeah)
    늦거나 빠른 건 없어
    우리 인생은 la-la-la-la-la-la
    평행선을 넘어 꿈의 노를 저어보자
    행복의 시간은 마음속 주머니에 가득 차
    서두르지 마 늘 충분하니까 그대로 있어도 돼
    나의 여행의 시작은 나야
    저 태양 위로 my my my my my way
    한 걸음마다 가까이 가까이 oh-ooh-oh
    내가 바라던 곳이야
    흔들리지 않게 맘을 잡아
    나에게로 oh-oh-oh-oh 가까이 my my way
    BRRRR BAA
    두 손 가득히 쥔 모든 것을
    BRRRR BAA
    날 위해 내버려도 괜찮아
    Hey 어딘가로 더 가까이 Hey (어디로 가?)
    아직은 undecided hey hey
    아무도 정해주지 못해
    나만이 La-la-la-la-la-la
    바다 위를 날아 꿈의 날개 펼쳐보자
    행복의 무게는 아무도 정하지 못하니까
    서두르지마 늘 충분하니까 그대로 있어도 돼
    나의 여행의 시작은 나야
    저 태양 위로 my my my my my way
    한 걸음마다 가까이 가까이 oh-ooh-oh
    내가 바라던 곳이야
    흔들리지않게맘을잡아
    나에게로 oh-oh-oh-oh 가까이 my my way
    내 삶은 여행 여행 여행
    내 맘을 걷네 걷네
    이 길은 나의 road movie
    내 길은 오랜 노래 노래
    저 태양 위로 my my my my my way (ah!)
    한 걸음마다 가까이 가까이
    내가 바라던 곳이야
    흔들리지 않게 맘을 잡아
    나에게로 oh-oh-oh-oh 가까이 my my way
    """
// swiftlint:enable line_length
// swiftlint:enable private_over_fileprivate
