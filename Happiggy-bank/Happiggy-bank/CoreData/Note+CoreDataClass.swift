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
}
