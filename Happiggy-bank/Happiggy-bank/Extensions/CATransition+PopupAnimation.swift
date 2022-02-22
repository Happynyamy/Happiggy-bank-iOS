//
//  CATransition+PopupAnimation.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

extension CATransition {
    
    /// 뷰가 사라질 때 페이드 아웃 효과를 나타냄
    func fadeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight

        return transition
    }
}
