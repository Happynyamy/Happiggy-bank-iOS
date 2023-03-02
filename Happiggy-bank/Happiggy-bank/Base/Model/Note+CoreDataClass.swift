//
//  Note+CoreDataClass.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/07.
//
//

import CoreData
import Foundation

@objc(Note)
/// 코어데이터의 쪽지 엔티티
public class Note: NSManagedObject {
    
    // MARK: - Static function
    
    /// 새로운 노트 엔티티를 생성하고 저금통과 연결해서 리턴함
    @discardableResult
    static func create(
        id: UUID,
        date: Date,
        color: NoteColor,
        content: String,
        imageURL: String? = nil,
        bottle: Bottle
    ) -> Note {
        let note = Note(id: id, date: date, color: color, content: content, imageURL: imageURL)
        bottle.addToNotes_(note)
        
        return note
    }
    
    /// sortDescriptor 를 설정하지 않으면 (생성 날짜) 최신순으로 정렬
    static func fetchRequest(
        predicate: NSPredicate,
        sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(
            key: "date_",
            ascending: false
        )]
    ) -> NSFetchRequest<Note> {
        NSFetchRequest<Note>(entityName: Note.name).then {
            $0.predicate = predicate
            $0.sortDescriptors = sortDescriptor
        }
    }
    
    /// 저금통의 모든 쪽지를 호출하는 리퀘스트로 순서를 지정하지 않으면 (오래된) 날짜 순서로 정렬
    static func fetchRequest(
        bottle: Bottle,
        sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(
            key: "date_",
            ascending: true
        )]
    ) -> NSFetchRequest<Note> {
        NSFetchRequest<Note>(entityName: Note.name).then {
            $0.sortDescriptors = sortDescriptor
            $0.predicate = NSPredicate(format: "bottle_ == %@", argumentArray: [bottle])
            $0.sortDescriptors = sortDescriptor
        }
    }
    
    
    // MARK: - Init(s)
    
    /// 주어진 날짜, 색깔, 내용을 갖는 쪽지 인스턴스를 코어데이터에 새로 생성하고 저금통과도 연결함
    /// 아이디는 자체적으로 생성하고 isOpen 은 자동으로 false 로 설정
    /// 저장은 별도로 해야 함
    convenience init(id: UUID, date: Date, color: NoteColor, content: String, imageURL: String?) {
        self.init(context: PersistenceStore.shared.context)
        self.id_ = id
        self.date_ = date
        self.color_ = color.rawValue
        self.content_ = content
        if let imageURL = imageURL {
            self.imageURL = imageURL
        }
    }
    
    
    // MARK: - (nil-coalesced) Properties
    
    /// 고유 아이디
    public var id: UUID { self.id_ ?? UUID() }
    
    /// 생성 날짜
    var date: Date { self.date_ ?? Date() }
    
    /// 내용
    var content: String { self.content_ ?? StringLiteral.content }
    
    /// 색깔
    var color: NoteColor {
        NoteColor(rawValue: self.color_ ?? NoteColor.default.rawValue) ?? NoteColor.default
    }
    
    /// 담겨있는 저금통
    var bottle: Bottle { self.bottle_ ?? Bottle() }
    
    /// 내용의 첫 번째 유효한 단어
    lazy var firstWord: String = {
        
        var firstWord = self.content
            .components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
            .first { !$0.isEmpty } ?? .empty

        /// 첫 단어가 10글자를 넘으면 1...10 의 범위에서 랜덤으로 길이 설정
        if firstWord.count > Metric.firstWordMaxLength {
            firstWord = String(firstWord.prefix(Metric.firstWordRandomLength))
        }
        
        return firstWord
    }()
}

// MARK: - Mock Data

extension Note {

    private static let lyrics = { """
    🍎
    I'm standing on the edge 🙌
    난 가장 높은 곳에서 123
    456 Everything is upside down
    ☺️ 두렵지 않아 break it down
    당당히 서 있어 ✅ with my toes
    Everybody listen up now
    No 더 이상은 no turnin' back
    No turnin' 🔥back, no turnin' back
    789 No, don't be scared
    003 아슬하게, 아찔하게 ˊ°̮ˋ
    두 손을 펼쳐 12329 up in the air
    Up in the air☀️, up in the air
    망설이지 마, 뭐 어때? (‘∀`)ゝ”
    When I move (  ¯⌓¯)
    너의 body를 흔들어봐 🤬 when I move
    When I move ~!@!)(
    더 자유롭게 breakin' all the rules
    When I 🤬 moveXD
    리듬에 맡겨 느낀 그대로 🥬
    이런 move 나의 move $%#^@$
    Oh, when I move:(
    Oh, whats the problem? ː̗̀(ꙨꙨ)ː̖́
    점점 빠져드는 123~~~ 이 공간의 flow
    나조차도 어림잡지 못해 out of my control
    홀린 듯 몸을 맡겨, 이 끌림이 싫진 않잖아
    그치? 🎉 나를 따라 너를 던져봐 (너를 던져봐)
    No 더 이상은 no 10^^ turnin' back
    No turnin' back, no turnin' back
    No, don't be scared:)
    아슬하게,✿◕ ‿ ◕✿ 아찔하게
    두 손을 펼쳐 up in the air 🥳
    Up in the air, up in the air
    ヽ(ﾟДﾟ)ﾉ 망설이지 마 we just dance~~~
    When I move📱
    너의 body를 흔들어봐 when I move
    When I move ʕ•ᴥ•ʔ
    더 자유롭게 breakin' all the rules
    When I move!!#$%^&*()_+~
    리듬에 맡겨 느낀 그대로
    이런 ❁_❁ move 나의 move
    Oh, when ✉️ I move
    다시 move again 109238
    We 1231waited for this time
    아찔하게 흔들어 roller coaster ride
    😃아스팔트에서 피운 꽃 strong survive
    ≧◡≦ 춤춰봐, 더 자유롭게 미쳐봐
    Shake your body, bounce your body
    왔어 우리에게 너무 좋은 날이 (날이)
    Move your body 들려, 내 말이?
    너가 원했던 이 순간이🍎☺️🧐💤👏
    멈추지 마, 계속 on my way
    I'll never look back oh, baby
    움츠렸던 마음을 녹여, 어제의 너를 잊어
    Moving (๑°ㅁ°๑)‼✧ on baby 셣
    When I (ง︡'-'︠)ง (move)
    너의 body를 🫥흔들어봐 when I move
    When I move (and I move, and I move)
    더 자유롭게 🧚‍♀️ breakin' all the rules
    When I (〃⌒▽⌒〃)ゝ move fJDAF
    ( °࿁° ) 리듬에 맡겨 느낀 그대로 뷁
    이런 move 🧶 나의 move $#@$*
    Oh, when 🐱 I move
    When I move !@FDSfhi
    😎 끝까지 손을 뻗어 when I move
    When I move 그래~~~욜ㅇ뛣
    We goin' higher breakin' all the rules
    Watch 🧐me move
    널 사로잡은 우리만의 move ( ͡❛ ͜ʖ ͡❛)
    When I move, when I move
    Oh, when I move 띠용 🥰
    """
        .split(separator: "\n")
        .map { String($0) } + Array(repeating: "\n", count: 10)
    }()

    /// 인자를 별도로 설정하지 않으면 오늘 날짜의 3줄 짜리 사진이 있는 노랑 쪽지 리턴
    @discardableResult
    static func createMockNote(
        for bottle: Bottle,
        date: Date,
        numberOfLines: Int = 3,
        hasPhoto: Bool = true,
        color: NoteColor = .yellow
    ) -> Note {
        let imageURL = hasPhoto ? "someURL" : nil
        let numberOfLines = 1...20 ~= numberOfLines ? numberOfLines : 1
        let lyrics = lyrics.shuffled()
        let content = (0..<numberOfLines).map { lyrics[$0] }

        return Note.create(
            id: UUID(),
            date: date,
            color: color,
            content: content.joined(separator: "\n"),
            imageURL: imageURL,
            bottle: bottle
        )
    }

    /// 줄 수와 색상과 사진 여부가 랜덤이 쪽지 리턴
    @discardableResult
    static func createRandomNote(for bottle: Bottle, date: Date) -> Note {
        createMockNote(
            for: bottle,
            date: date,
            numberOfLines: (1...20).randomElement()!,
            hasPhoto: [true, false].randomElement()!,
            color: NoteColor.allCases.randomElement()!
        )
    }
}
