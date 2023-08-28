//
//  NewNoteSavingDelegate.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/16.
//

import Foundation

/// 새로운 쪽지를 추가했을 때 이를 알림받아야 하는 클래스가 채택하는 프로토콜
protocol NewNoteSavingDelegate: AnyObject {

    /// 새로운 쪽지가 추가되었음을 전달
    func newNoteDidSave(_ note: Note)
}
