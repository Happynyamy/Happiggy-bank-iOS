//
//  NSNotificaion.Name+CustomNotifications.swift.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/27.
//

import Foundation

extension NSNotification.Name {
    
    /// 새로운 쪽지 작성으로 쪽지 진행 정도가 변화했을 때 보내는 알림 이름
    static let noteDidAdd = NSNotification.Name("note-did-add")
    
    /// 유저가 폰트 변경 시 보내는 알림 이름
    static let customFontDidChange = NSNotification.Name("custom-font-did-change")
    
    /// 앱스토어 정보를 불러왔을 때 보내는 알림 이름
    static let appStoreInfoDidLoad = NSNotification.Name("app-store-info-did-load")
}
