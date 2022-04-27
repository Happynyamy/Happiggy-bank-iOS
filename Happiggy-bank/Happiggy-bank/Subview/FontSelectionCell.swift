//
//  FontSelectionCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/22.
//

import UIKit

/// 폰트 선택 뷰에서 사용하는 셀
final class FontSelectionCell: UITableViewCell {
    
    // MARK: - @IBOutlets
    
    /// 폰트 이름 라벨
    @IBOutlet weak var fontNameLabel: UILabel!
    
    /// 선택 표시 이미지 뷰
    @IBOutlet weak var checkmarkImageView: UIImageView!
    

    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.fontNameLabel.text = nil
        self.fontNameLabel.attributedText = nil
        self.checkmarkImageView.isHidden = true
    }
}
