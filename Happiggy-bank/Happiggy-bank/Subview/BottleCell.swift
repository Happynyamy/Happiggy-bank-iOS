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

    /// 셀 배경이미지
    @IBOutlet var bottleCellBackground: UIImageView!
    
    /// 저금통 프레임 이미지
    @IBOutlet var bottleFrameImage: UIImageView!

    /// 저금통 뚜껑 이미지
    @IBOutlet var bottleCapImage: UIImageView!
    
    /// 저금통 제목 라벨
    @IBOutlet var bottleTitleLabel: UILabel!

    /// 저금통 기간 라벨
    @IBOutlet var bottleDateLabel: UILabel!

    
    // MARK: - override func
    
    override func awakeFromNib() {
        configureCellBackground()
        configureCellBottleFrame()
        configureCellBottleCap()
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
    
    // TODO: 인터페이스 빌더 상에 바로 추가?
    // TODO: 에셋 이미지 이름 수정
    /// 셀 배경 이미지 설정
    private func configureCellBackground() {
//        self.bottleCellBackground.image = UIImage(named: StringLiteral.backgroundImage)
        self.bottleCellBackground.contentMode = .scaleAspectFill
        self.bottleCellBackground.layer.cornerRadius = Metric.cornerRadius
    }
    
    /// 셀 저금통 프레임 이미지 설정
    private func configureCellBottleFrame() {
        self.bottleFrameImage.image = UIImage(named: StringLiteral.bottleFrameImage)
        self.bottleFrameImage.contentMode = .scaleAspectFill
    }
    
    /// 셀 저금통 뚜껑 이미지 설정
    private func configureCellBottleCap() {
        self.bottleCapImage.image = UIImage(named: StringLiteral.bottleCapImage)
        self.bottleCapImage.contentMode = .scaleAspectFill
    }
    
    /// 셀 라벨 폰트사이즈, 색상 설정
    private func configureLabels() {
        self.bottleTitleLabel.font = .systemFont(ofSize: FontSize.titleLabel)
        self.bottleDateLabel.font = .systemFont(ofSize: FontSize.dateLabel)
        self.bottleDateLabel.textColor = UIColor(hex: Color.dateLabelText)
    }
}
