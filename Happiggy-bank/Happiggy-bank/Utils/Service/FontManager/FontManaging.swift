//
//  FontManaging.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/15.
//

import Foundation

/// Font 변경을 관리하며 FontPublishing 프로토콜을 채택
protocol FontManaging: FontPublishing {

    // MARK: - Properties

    /// 현재 폰트
    var font: CustomFont { get }


    // MARK: - Functions

    /// 폰트를 변경
    func fontDidChange(to font: CustomFont)
}
