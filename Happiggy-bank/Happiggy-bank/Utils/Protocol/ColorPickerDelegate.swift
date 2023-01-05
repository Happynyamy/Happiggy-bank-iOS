//
//  ColorPickerDelegate.swift
//  Happiggy-bank
//
//  Created by sun on 2022/10/21.
//

import Foundation

/// 선택된 색상이 변경되었음을 알리는 메서드를 포함함
protocol ColorPickerDelegate: AnyObject {

    /// 인자로 주어진 색상으로 선택 색상이 변경되었음을 전달
    func selectedColorDidChange(to color: NoteColor)
}
