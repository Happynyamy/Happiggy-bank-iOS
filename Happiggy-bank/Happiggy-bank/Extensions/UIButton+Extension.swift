//
//  UIButton+Extension.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/25.
//

import UIKit

extension UIButton {
    
    /// 상태에 따라 버튼의 배경색을 지정해주는 함수
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
