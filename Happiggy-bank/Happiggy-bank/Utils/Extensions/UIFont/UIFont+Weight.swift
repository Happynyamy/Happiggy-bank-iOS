//
//  UIFont+Weight.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UIFont {
    
    /// 볼드체 여부
    var isBold: Bool {
        fontDescriptor.symbolicTraits.contains(UIFontDescriptor.SymbolicTraits.traitBold)
    }
}
