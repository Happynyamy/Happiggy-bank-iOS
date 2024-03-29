//
//  CustomTabBar.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/07.
//

import UIKit

/// 커스텀 탭바
final class CustomTabBar: UITabBar {
    
    // MARK: - Override Properties
    
    /// 스크롤 시 자동 생성되는 그림자 제거
    override var shadowImage: UIImage? {
        get { UIImage() }
        set { }
    }
    
    /// 스크롤 시 자동 생성되는 그림자 제거
    override var backgroundImage: UIImage? {
        get { UIImage() }
        set { }
    }
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureItemPositionsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureItemPositionsIfNeeded()
    }
    
    
    // MARK: - Override Functions
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        
        if UIScreen.main.bounds.height >= Metric.heightCap {
            size.height = Metric.height
        }

        return size
    }

    
    // MARK: - Functions

    /// 탭 아이템 위치 조정
    private func configureItemPositionsIfNeeded() {
        guard UIScreen.main.bounds.height >= Metric.heightCap
        else { return }
        
        self.items?.forEach {
            $0.imageInsets = Metric.imageInset
            $0.titlePositionAdjustment.vertical = Metric.titleOffset
        }
    }
}

extension CustomTabBar {
    
    /// 상수값
    enum Metric {
        
        /// 높이 : 89
        static let height: CGFloat = 89
        
        /// 아이템 제목 오프셋: 4
        static let titleOffset: CGFloat = 4
        
        /// 아이템 인셋: (4, 0, -4, 0)
        static let imageInset = UIEdgeInsets(
            top: titleOffset,
            left: .zero,
            bottom: -titleOffset,
            right: .zero
        )
        
        /// 커스텀 탭바 크기를 적용할 디바이스 최소 높이
        static let heightCap: CGFloat = 800
    }
}
