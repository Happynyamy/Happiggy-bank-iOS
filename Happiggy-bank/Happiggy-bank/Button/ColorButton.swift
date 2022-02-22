//
//  ColorButton.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

/// ColorPalette 에서 사용되는 버튼으로,  선택 가능한 note 색상을 나타냄
final class ColorButton: DefaultButton {
    
    convenience init(_ color: UIColor) {
        self.init()
        
        self.backgroundColor = color
        self.layer.cornerRadius = Metric.cornerRadius
        if color == .white {
            self.layer.borderWidth = Metric.borderWidth
            self.layer.borderColor = UIColor.systemGray4.cgColor
        }
        self.isHighlighted = false
    }
}
