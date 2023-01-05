//
//  Array+SafeIndex.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/27.
//

import Foundation

extension Array {

    /// 크래시 방지를 위해 조회하려는 index가 해당 배열의 범위 내에 존재하는 지 확인하고,
    /// 존재하는 경우 해당 위치의 값을, 존재하지 않는 경우 nil 리턴
    subscript(safe index: Int) -> Element? {
        self.indices ~= index ? self[index] : nil
    }
}
