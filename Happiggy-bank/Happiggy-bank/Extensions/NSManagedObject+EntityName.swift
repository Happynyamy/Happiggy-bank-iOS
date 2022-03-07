//
//  NSManagedObject+EntityName.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/08.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    /// 휴먼 에러 방지를 위한 entityName 생성 프로퍼티
    static var entityName: String {
        String(describing: self).components(separatedBy: ".").last!
    }
}
