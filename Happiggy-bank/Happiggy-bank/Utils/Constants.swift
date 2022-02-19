//
//  Constants.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

extension HomeViewController {
    
    /// HomeViewController 에서  설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 뷰 간 간격
        static let spacing: CGFloat = 8
        
        /// BottleView 의 높이/너비 값
        static let pageViewHeightWidthRatio: CGFloat = 480 / 375
        
        /// 좌우 패딩 값
        static let verticalPadding: CGFloat = 24
        
        /// 버튼 높이
        static let buttonHeight: CGFloat = 48
        
        /// 버튼 길이(높이와 동일)
        static let buttonWidth: CGFloat = buttonHeight
        
        // 라벨 높이(버튼 높이와 동일)
        static let labelHeight: CGFloat = buttonHeight
        
        /// noteProgress 라벨 너비
        static let noteProgressLabelWidth: CGFloat = 126
        
        /// list Button의 앞쪽 패딩
        static let listButtonLeadingPadding: CGFloat = 88
    }
}

extension BottleViewController {
    
    /// BottleViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// TODO: 모든 뷰에서 같으면 전역으로 만들기
        /// 좌우 패딩 값
        static let verticalPadding: CGFloat = HomeViewController.Metric.verticalPadding
    }
}

extension HomeViewButton {

    /// HomeViewButton 에서 설정하는 layout에 적용할 상수값
    enum Metric {
        
        /// 버튼 높이
        static let buttonHeight: CGFloat = HomeViewController.Metric.buttonHeight
        
        /// 버튼 너비
        static let buttonWidth: CGFloat = HomeViewController.Metric.buttonWidth
    }
}
