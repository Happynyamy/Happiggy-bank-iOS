//
// UINavigationBar+Clear.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import UIKit

extension UINavigationBar {
    
    /// 내비게이션 바를 투명하게 변경
    func clear() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}
