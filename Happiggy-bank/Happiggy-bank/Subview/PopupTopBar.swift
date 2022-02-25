//
//  PopupTopBar.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/25.
//

import UIKit

import Then

/// 팝업 상단바 뷰
final class PopupTopBar: UIView {
    
    /// 상단 바 취소 버튼
    let cancelButton = DefaultButton(buttonTitle: "취소").then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 상단 바 타이틀 라벨
    let titleLabel = UILabel().then {
        $0.text = "유리병 추가하기"
        $0.font = .systemFont(ofSize: 17)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 상단 바 구성
    private func configureView() {
        let bottomBorder: CALayer = CALayer()
        let thickness = 1.0
        
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.viewWidth,
            height: Metric.viewHeight
        )
        
        bottomBorder.frame = CGRect(
            x: 0,
            y: self.frame.height - thickness,
            width: Metric.viewWidth,
            height: thickness
        )
        bottomBorder.backgroundColor = UIColor(hex: 0xEFEFEF).cgColor
        self.layer.addSublayer(bottomBorder)
    }
    
    /// 상단 바 하위 뷰 추가
    private func addComponents() {
        self.addSubview(cancelButton)
        self.addSubview(titleLabel)
    }
}
