//
//  UIView+HideShowWithAnimation.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/27.
//

import UIKit

extension UIView {
    
    /// 애니메이션과 함께 뷰를 숨기는 메서드
    /// 디폴트 설정은 애니메이션 시간 : 0.2, options: curveEaseInOut, otherAnimations: nil, completion: nil
    func hideWithAnimation(
        duration: TimeInterval = CATransition.transitionDuration,
        options: AnimationOptions = [.curveEaseInOut],
        otherAnimations: (() -> Void)? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.transition(with: self, duration: duration, options: options) {
            self.isHidden = true
            
            guard let otherAnimations = otherAnimations
            else { return }

            otherAnimations()
            
        } completion: { result in
            guard let completion = completion
            else { return }
            
            completion(result)
        }
    }
    
    /// 애니메이션과 함께 숨겼던 뷰를 다시 나타내는 메서드
    /// 디폴트 설정은  애니메이션 시간 : 0.2, options: curveEaseInOut, otherAnimations: nil, completion: nil
    func showWithAnimation(
        duration: TimeInterval = CATransition.transitionDuration,
        options: AnimationOptions = [.curveEaseInOut],
        otherAnimations: (() -> Void)? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.transition(with: self, duration: duration, options: options) {
            self.isHidden = false
            
            guard let otherAnimations = otherAnimations
            else { return }

            otherAnimations()
            
        } completion: { result in
            guard let completion = completion
            else { return }
            
            completion(result)
        }
    }
}
