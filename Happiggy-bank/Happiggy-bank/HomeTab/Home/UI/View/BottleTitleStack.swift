//
//  BottleTitleStack.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/01/03.
//

import UIKit

import SnapKit
import Then

/// 저금통이 진행중일 때 나타나는 저금통 이름 스택 뷰
final class BottleTitleStack: UIStackView {
    
    /// 저금통이 진행중일 때 나타나는 저금통 이름 라벨
    lazy var bottleTitleLabel: UILabel = BaseLabel().then {
        $0.text = "bottle title"
        $0.changeFontSize(to: FontSize.title1)
    }
    
    /// 저금통이 진행중일 때 나타나는 저금통 이름 라벨 옆 스마일 이미지
    lazy var bottleTitleSmileImage: UIImageView = UIImageView().then {
        $0.image = AssetImage.smile
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        configureImage()
        configureLabel()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 스택 뷰 설정
    private func configureStackView() {
        self.axis = .horizontal
        self.spacing = .zero
        self.alignment = .fill
        self.distribution = .fill
        self.addArrangedSubviews([self.bottleTitleLabel, self.bottleTitleSmileImage])
        self.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        self.isLayoutMarginsRelativeArrangement = true
    }
    
    /// 스마일 이미지 설정
    private func configureImage() {
        self.bottleTitleSmileImage.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(self.bottleTitleSmileImage.snp.width)
        }
    }
    
    /// 저금통 이름 라벨 설정
    private func configureLabel() {
        self.bottleTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(self.bottleTitleSmileImage.snp.height)
        }
    }
}
