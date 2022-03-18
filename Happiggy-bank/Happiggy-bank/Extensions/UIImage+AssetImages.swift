//
//  UIImage+AssetImages.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/18.
//

import UIKit

extension UIImage {
    
    /// 쪽지 에셋 이미지를 반환하는 메서드
    static func note(color: NoteColor) -> UIImage {
        UIImage(named: Asset.note.rawValue + color.capitalizedString) ?? UIImage()
    }
}
