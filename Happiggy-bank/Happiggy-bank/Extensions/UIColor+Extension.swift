//
//  UIColor+Extension.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/25.
//

import UIKit

extension UIColor {
    
    /// hex값을 이용해 색상을 초기화
    convenience init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(red: red, green: green, blue: blue, alpha: opacity)
    }
}
