//
//  UIView+ZoomAnimation.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/31.
//

import UIKit

extension UIView {
    
    // MARK: - Enums
    
    /// 줌 애니메이션 관련 상수값
    private enum ZoomAnimation {
        
        /// 축소(줌 아웃) 스케일: 0.9
        static let transformDownScale: CGFloat = 0.9
        
        /// 확대(줌 인) 스케일: 1.1
        static let transformUpScale: CGFloat = 1.1
        
        /// 축소 효과(1.0 -> 0.9) 시작: 1/4
        static let scaleDownRelativeStart: Double = .zero

        /// 축소 효과(1.0 -> 0.9) 시간: 0
        static let scaleDownRelativeDuration: Double = 1/4

        /// 확대 효과(0.9 -> 1.1) 시작: 1/4
        static let scaleUpRelativeStart: Double = scaleDownRelativeDuration

        /// 확대 효과(0.9 -> 1.1) 시간: 2/4
        static let scaleUpRelativeDuration: Double = 2/4

        /// 원래 사이즈로 돌아가는 효과(1.1-> 1.0)의 시작: 3/4
        static let identityRelativeStart: Double = scaleUpRelativeStart + scaleUpRelativeDuration

        /// 원래 사이즈로 돌아가는 효과(1.1-> 1.0)의 시간: 1/4
        static let identityRelativeDuration: Double = 1/4
    }
    
    
    // MARK: - Functions
    
    /// 뷰를 줌(축소->확대->원래 크기)하는 애니메이션 효과
    func zoomAnimation(
        duration: Double,
        delay: Double = .zero,
        downScale: Double = ZoomAnimation.transformDownScale,
        upScale: Double = ZoomAnimation.transformUpScale,
        fadeIn: Bool = false,
        options: UIView.KeyframeAnimationOptions = [],
        completion: ((Bool) -> Void)? = nil
    ) {
        if fadeIn {
            self.alpha = .zero
        }
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: delay,
            options: options
        ) {
            self.addZoomAnimationKeyFrame(
                scale: downScale,
                relativeStartTime: ZoomAnimation.scaleDownRelativeStart,
                relativeDuration: ZoomAnimation.scaleDownRelativeDuration
            )
            self.addZoomAnimationKeyFrame(
                scale: upScale,
                relativeStartTime: ZoomAnimation.scaleUpRelativeStart,
                relativeDuration: ZoomAnimation.scaleUpRelativeDuration
            )
            UIView.addKeyframe(
                withRelativeStartTime: ZoomAnimation.identityRelativeStart,
                relativeDuration: ZoomAnimation.identityRelativeDuration
            ) {
                self.transform = .identity
            }
            
            guard fadeIn
            else { return }
            
            self.alpha = .one

        } completion: { result in
            guard let completion = completion
            else { return }
            
            completion(result)
        }
    }
    
    /// 줌 애니메이션 생성을 위한 syntatic sugar
    private func addZoomAnimationKeyFrame(
        scale: CGFloat,
        relativeStartTime: Double,
        relativeDuration: Double
    ) {
        UIView.addKeyframe(
            withRelativeStartTime: relativeStartTime,
            relativeDuration: relativeDuration
        ) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
