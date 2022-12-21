//
//  DebugPrint.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/21.
//

import Foundation

/// 디버깅 시에만 내용을 출력, Swift의 print문과 인자 동일
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
