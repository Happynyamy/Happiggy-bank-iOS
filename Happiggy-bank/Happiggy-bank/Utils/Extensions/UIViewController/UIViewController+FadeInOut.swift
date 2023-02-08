//
//  UIViewController+FadeInOut.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

extension UIViewController {
    
    /// 뷰가 나타날 때 페이드인 효과를 주기 위한 syntactic sugar
    func fadeIn() {
        guard let window = self.view.window
        else { return }
        
        window.layer.add(CATransition.fadeTransition(), forKey: kCATransition)
    }
    
    /// 뷰가 사라질 때 페이드아웃 효과를 주기 위한 syntactic sugar
    func fadeOut() {
        guard let window = self.view.window
        else { return }
        
        window.layer.add(CATransition.fadeTransition(), forKey: kCATransition)
    }
}
