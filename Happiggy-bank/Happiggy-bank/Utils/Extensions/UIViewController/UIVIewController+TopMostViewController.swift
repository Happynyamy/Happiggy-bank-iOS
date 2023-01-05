//
//  UIVIewController+TopMostViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/09.
//

import UIKit

extension UIViewController {
    
    /// 해당 뷰 컨트롤러가 속한 뷰 체계에서 가장 상위에 있는 뷰 컨트롤러를 리턴함
    func topMostViewController() -> UIViewController? {
        
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigationController = self.presentedViewController as? UINavigationController {
            let navigationTopViewController = navigationController.topViewController
            
            guard navigationTopViewController?.presentedViewController != nil
            else { return navigationTopViewController }
            
            return navigationTopViewController?.presentedViewController?.topMostViewController()
        }
        
        if let tabBarContoller = self.presentedViewController as? UITabBarController {
            if let selectedTab = tabBarContoller.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tabBarContoller.topMostViewController()
        }
        
        return self.presentedViewController?.topMostViewController()
    }
}
