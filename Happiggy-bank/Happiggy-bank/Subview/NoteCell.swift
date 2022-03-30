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
    
    /// 쪽지 작성 날짜 라벨
    @IBOutlet weak var dateLabel: UILabel!
    
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
        self.dateLabel.text = nil
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
