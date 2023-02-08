//
//  UINavigationController+transition.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/08.
//

import UIKit

extension UINavigationController {
    
    /// fadeout 효과 적용된 상태로 뷰 컨트롤러 pop
    @discardableResult
    func popViewControllerWithFade() -> UIViewController? {
        self.fadeOut()
        return self.popViewController(animated: false)
    }
    
    /// fadeout 효과 적용된 상태로 루트 뷰로 pop
    @discardableResult
    func popToRootViewControllerWithFade() -> [UIViewController]? {
        self.fadeOut()
        return self.popToRootViewController(animated: false)
    }
    
    /// fadein 효과 적용된 상태로 뷰 컨트롤러 push
    /// - Parameters:
    ///    - to: push할 뷰 컨트롤러
    func pushViewControllerWithFade(to viewController: UIViewController) {
        self.fadeIn()
        self.pushViewController(viewController, animated: false)
    }
}
