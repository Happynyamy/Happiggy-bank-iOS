//
//  FontManaging.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/15.
//

import Foundation

/// FontChanging 프로토콜과 FontPublishing 프로토콜을 채택
protocol FontManaging: FontChanging, FontPublishing {
    
    var font: CustomFont { get }
}
