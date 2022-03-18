//
//  UIView+FadeInOut.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/19.
//

import UIKit

extension UIView {
    
    /// 애니메이션 지속 시간: 0.2
    private static let animationDuration: TimeInterval = 0.2
    
    /// 페이드 인 애니메이션: 디폴트 지속 시간 0.2, 딜레이 0, curveEaseInOut, completion nil
    func fadeIn(
        withDuration duration: TimeInterval = animationDuration,
        delay: TimeInterval = .zero,
        options: AnimationOptions = AnimationOptions.curveEaseInOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: { self.alpha = .one },
            completion: completion)
    }
    
    /// 페이드 아웃 애니메이션: 디폴트 지속 시간 0.2, 딜레이 0, curveEaseInOut, completion nil
    func fadeOut(
        withDuration duration: TimeInterval = animationDuration,
        delay: TimeInterval = .zero,
        options: AnimationOptions = AnimationOptions.curveEaseInOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: { self.alpha = .zero },
            completion: completion
        )
    }
}
