//
//  UIView+FadeInOut.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/19.
//

import UIKit

extension UIView {

    // MARK: - Properties

    /// 애니메이션 지속 시간: 0.2
    private static let animationDuration: TimeInterval = 0.2


    // MARK: - Functions

    /// 해당 뷰를 애니메이션 효과와 함께 나타냄(IsHidden = false)
    ///
    /// 부모 뷰가 없는 경우 애니메이션 효과 없이 isHidden = false 로만 변경
    /// - Parameters:
    ///   - containerView: 해당 뷰의 부모 뷰, 입력하지 않으면 해당 뷰의 부모 뷰에 self.superview로 접근
    ///   - duration: 애니메이션 지속 시간, 기본 값: 0.2
    ///   - delay: 딜레이 시간, 기본 값: 0
    ///   - options: 애니메이션 옵션, 기본 값: transitionCrossDissolve
    ///   - completion: 애니메이션 종료 후 할 작업, 기본 값: nil
    func fadeIn(
        containerView: UIView? = nil,
        duration: TimeInterval = animationDuration,
        delay: TimeInterval = .zero,
        options: AnimationOptions = .transitionCrossDissolve,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard let containerView = containerView ?? self.superview
        else {
            self.isHidden = false
            print("부모 뷰가 없어 페이드 인 실패")
            return
        }

        UIView.transition(
            with: containerView,
            duration: duration,
            // 애니메이션 효과에 필수적이라 인자를 직접 넣는 경우에도 누락 방지를 위해 union 처리
            options: options.union([.transitionCrossDissolve]),
            animations: { [weak self] in self?.isHidden = false },
            completion: completion
        )
    }
    
    /// 해당 뷰를 애니메이션 효과와 함께 숨김(IsHidden = true)
    ///
    /// 부모 뷰가 없는 경우 애니메이션 효과 없이 isHidden = true 로만 변경
    /// - Parameters:
    ///   - containerView: 해당 뷰의 부모 뷰, 입력하지 않으면 해당 뷰의 부모 뷰에 self.superview로 접근
    ///   - duration: 애니메이션 지속 시간, 기본 값: 0.2
    ///   - delay: 딜레이 시간, 기본 값: 0
    ///   - options: 애니메이션 옵션, 기본 값: transitionCrossDissolve
    ///   - completion: 애니메이션 종료 후 할 작업, 기본 값: nil
    func fadeOut(
        containerView: UIView? = nil,
        duration: TimeInterval = animationDuration,
        delay: TimeInterval = .zero,
        options: AnimationOptions = .transitionCrossDissolve,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard let containerView = containerView ?? self.superview
        else {
            self.isHidden = true
            print("부모 뷰가 없어 페이드 아웃 실패")
            return
        }

        UIView.transition(
            with: containerView,
            duration: duration,
            /// 애니메이션 효과에 필수적이라 인자를 직접 넣는 경우에도 누락 방지를 위해 union 처리
            options: options.union([.transitionCrossDissolve]),
            animations: { [weak self] in self?.isHidden = true },
            completion: completion
        )
    }
}
