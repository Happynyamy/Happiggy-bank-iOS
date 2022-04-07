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
        
        self.configureDivider()
        self.configureItemPositions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configureDivider()
        self.configureItemPositions()
    }
    
    
    // MARK: - Override Functions
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = Metric.height

        return size
    }

    
    // MARK: - Functions
    
    /// 상단에 구분선 생성
    private func configureDivider() {
        let dividerView = UIView().then {
            $0.frame = CGRect(
                x: .zero,
                y: .zero,
                width: UIScreen.main.bounds.width,
                height: .one
            )
            $0.backgroundColor = .tabBarDivider
        }
        self.addSubview(dividerView)
    }
    
    /// 탭 아이템 위치 조정
    private func configureItemPositions() {
        self.items?.forEach {
            $0.imageInsets = Metric.imageInset
            $0.titlePositionAdjustment.vertical = Metric.titleOffset
        }
    }
}
