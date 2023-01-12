//
//  BottleCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit

import Then

// TODO: Label -> BaseLabel
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
        self.bottleImage.clipsToBounds = true
    }
    
    /// 셀 라벨 폰트사이즈, 색상 설정
    private func configureLabels() {
        self.bottleTitleLabel.font = .systemFont(ofSize: FontSize.titleLabel)
        self.bottleDateLabel.font = .systemFont(ofSize: FontSize.dateLabel)
        self.bottleDateLabel.textColor = .customLabel
    }
}

extension BottleCell {
    
    /// 리유저블 ID 이름
    static var reuseIdentifier: String {
        return "\(self)"
    }
    
    /// 인터페이스 빌더 파일 이름
    static var nibName: String {
        return "\(self)"
    }
    
    /// Bottle Cell에서 설정하는 layout 상수값
    enum Metric {
        
        /// corner radius
        static let cornerRadius: CGFloat = 7
    }
    
    /// Bottle Cell에서 설정하는 글자 크기
    enum FontSize {
        
        /// 유리병 제목 라벨 글자 크기
        static let titleLabel: CGFloat = 16
        
        /// 유리병 기간 라벨 글자 크기
        static let dateLabel: CGFloat = 12
    }
}
