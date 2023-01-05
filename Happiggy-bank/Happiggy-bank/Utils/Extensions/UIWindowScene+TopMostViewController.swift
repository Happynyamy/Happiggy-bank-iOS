//
//  UIWindowScene+TopMostViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/09.
//

import UIKit

extension UIWindowScene {

    /// 현재 윈도우의 최상단에 있는 뷰 컨트롤러 리턴
    var topMostViewController: UIViewController? {
        self.windows
            .filter { $0.isKeyWindow }
            .first?
            .rootViewController?
            .topMostViewController()
    }
}
