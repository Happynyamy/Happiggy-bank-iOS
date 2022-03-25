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
    static func create(date: Date, color: NoteColor, content: String, bottle: Bottle) -> Note {
        let note = Note(date: date, color: color, content: content)
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
    
    /// 저금통의 모든 쪽지를 호출하는 리퀘스트로 순서를 지정하지 않으면 날짜가 빠른 순으로 정렬
    static func fetchRequest(
        bottle: Bottle,
        sortDescriptor: [NSSortDescriptor] = [NSSortDescriptor(
            key: "date_",
            ascending: false
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
    convenience init(date: Date, color: NoteColor, content: String) {
        self.init(context: PersistenceStore.shared.context)
        self.id_ = UUID()
        self.date_ = date
        self.color_ = color.rawValue
        self.content_ = content
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
    var firstWord: String {
        
        var firstWord = self.content
            .components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
            .first { !$0.isEmpty } ?? .empty

        /// 첫 단어가 10글자를 넘으면 10글자까지만 자름
        if firstWord.count > Metric.firstWordMaxLength {
            firstWord = String(firstWord.prefix(Metric.firstWordMaxLength))
        }
        
        return firstWord
    }
}
