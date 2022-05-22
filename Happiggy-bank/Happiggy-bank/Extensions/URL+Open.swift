//
//  URL+Open.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/22.
//

import UIKit

extension URL {
    
    /// url을 엶
    func open(completionHandler: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(self, options: [:], completionHandler: completionHandler)
    }
}
