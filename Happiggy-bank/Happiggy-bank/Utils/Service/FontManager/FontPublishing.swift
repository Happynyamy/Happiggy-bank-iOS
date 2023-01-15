//
//  FontPublishing.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/15.
//

import Combine

/// 폰트가 변경되면 이를 알리는 기능
protocol FontPublishing {
    
    var fontPublisher: Published<CustomFont>.Publisher { get }
}
