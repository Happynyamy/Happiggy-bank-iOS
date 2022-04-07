//
//  BottleCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit

import Then

/// 저금통 리스트의 셀
final class BottleCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// 저금통 이미지
    @IBOutlet weak var bottleImage: UIImageView!
    
    /// 저금통 제목 라벨
    @IBOutlet weak var bottleTitleLabel: UILabel!

    /// 저금통 기간 라벨
    @IBOutlet weak var bottleDateLabel: UILabel!
    
    
    // MARK: - override func
    
    override func awakeFromNib() {
        configureImage()
        configureLabels()
    }
    
    
    // MARK: - Cell Settings
    
    /// 셀 이미지 설정
    private func configureImage() {
        self.bottleImage.layer.cornerRadius = Metric.cornerRadius
    }
    
    /// 셀 라벨 폰트사이즈, 색상 설정
    private func configureLabels() {
        self.bottleTitleLabel.font = .systemFont(ofSize: FontSize.titleLabel)
        self.bottleDateLabel.font = .systemFont(ofSize: FontSize.dateLabel)
        self.bottleDateLabel.textColor = .customLabel
    }
}
