//
//  UIViewController+NotificationCenter.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/27.
//

import UIKit

extension UIViewController {
    
    /// NotificationCenter.default.addObserver 의 syntactic sugar
    func observe(selector: Selector, name: NSNotification.Name?) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    /// NotificationCenter.defaul.post 의 syntactic sugar
    func post(name: NSNotification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
}
