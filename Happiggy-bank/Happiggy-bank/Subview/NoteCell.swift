//
//  NoteCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/30.
//

import UIKit

/// 쪽지 디테일 뷰에서 사용하는 쪽지 셀
final class NoteCell: UICollectionViewCell {
    
    // MARK: - @IBOutlet
    
    /// 쪽지 작성 연도 라벨
    @IBOutlet weak var yearLabel: UILabel!
    
    /// 쪽지 작성 월, 일, 요일 라벨
    @IBOutlet weak var monthAndDayLabel: UILabel!
    
    /// 쪽지 내용 라벨
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 쪽지 배경 이미지
    @IBOutlet weak var noteImageView: UIImageView!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureContentLabel()
    }
    
    override func prepareForReuse() {
        self.noteImageView.image = UIImage()
        self.yearLabel.attributedText = nil
        self.monthAndDayLabel.attributedText = nil
        self.contentLabel.text = nil
        
    }
    
    
    // MARK: - Functions
    
    /// 내용 라벨 자간, 행간 설정
    private func configureContentLabel() {
        self.contentLabel.configureParagraphStyle(
            lineSpacing: Metric.lineSpacing,
            characterSpacing: Metric.characterSpacing
        )
    }
}
