//
//  BottleCollectionCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/01/12.
//

import UIKit

import Then

final class BottleCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// 저금통 이미지
    lazy var bottleImage: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = Metric.cornerRadius
        $0.clipsToBounds = true
    }
    
    /// 저금통 제목 라벨
    lazy var bottleTitleLabel: BaseLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body3)
    }

    /// 저금통 기간 라벨
    lazy var bottleDateLabel: BaseLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.caption1)
        $0.textColor = AssetColor.mainYellow
    }
}

extension BottleCollectionCell {
    
    /// 리유저블 ID 이름
    static var reuseIdentifier: String {
        return "\(self)"
    }
    
    /// Bottle Cell에서 설정하는 layout 상수값
    enum Metric {
        
        /// corner radius
        static let cornerRadius: CGFloat = 7
    }
}
