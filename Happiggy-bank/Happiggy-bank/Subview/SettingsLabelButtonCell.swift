//
//  SettingsLabelButtonCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/26.
//

import UIKit

/// 환경설정 뷰에서 라벨이 있는 항목을 위한 셀
final class SettingsLabelButtonCell: SettingsViewCell {
    
    // MARK: - @IBOutlets
    
    /// 아이콘 이미지 뷰
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 제목 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 버튼 역할을 하는 스택
    @IBOutlet weak var buttonStack: UIStackView!
    
    /// 버튼 스택의 정보 라벨
    @IBOutlet weak var informationLabel: UILabel!
    
    /// 버튼 이미지 뷰
    @IBOutlet weak var buttonImageView: UIView!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconImageView.image = UIImage()
        self.titleLabel.attributedText = nil
        self.titleLabel.text = nil
        self.informationLabel.attributedText = nil
        self.informationLabel.text = nil
        self.informationLabel.textColor = .label
        self.buttonImageView.isHidden = false
    }
}
