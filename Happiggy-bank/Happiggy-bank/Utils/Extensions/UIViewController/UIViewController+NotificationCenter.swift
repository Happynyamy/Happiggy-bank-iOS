//
//  UIViewController+NotificationCenter.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/27.
//

import UIKit

extension UIViewController {
    
    /// NotificationCenter.default.addObserver 의 syntactic sugar
    func observe(selector: Selector, name: NSNotification.Name?, object: Any? = nil) {
        NotificationCenter.default.addObserver(
            self, selector: selector, name: name, object: object
        )
    }
    
    /// NotificationCenter.defaul.post 의 syntactic sugar
    func post(name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}
