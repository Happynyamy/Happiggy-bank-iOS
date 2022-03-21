//
//  BottleCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit

import Then

// TODO: bottleContentView 필요 -> 쪽지 채워진 모양

/// 저금통 리스트의 셀
final class BottleCell: UITableViewCell {
    
    // MARK: - Properties
    
    /// 저금통 제목 라벨
    @IBOutlet weak var bottleTitleLabel: UILabel!

    /// 저금통 기간 라벨
    @IBOutlet weak var bottleDateLabel: UILabel!

    
    // MARK: - override func
    
    override func awakeFromNib() {
        configureLabels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: Metric.cellSpacing,
                left: Metric.horizontalPadding,
                bottom: 0,
                right: Metric.horizontalPadding
            )
        )
    }
    
    
    // MARK: - cell settings
    
    /// 셀 라벨 폰트사이즈, 색상 설정
    private func configureLabels() {
        self.bottleTitleLabel.font = .systemFont(ofSize: FontSize.titleLabel)
        self.bottleDateLabel.font = .systemFont(ofSize: FontSize.dateLabel)
        self.bottleDateLabel.textColor = UIColor(hex: Color.dateLabelText)
    }
}
