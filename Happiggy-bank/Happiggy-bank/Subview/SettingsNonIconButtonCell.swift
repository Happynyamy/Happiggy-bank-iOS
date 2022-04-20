//
//  SettingsNonIconButtonCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/22.
//

import UIKit

/// 환경설정 하위 항목들에서 사용하는 아이콘이 없는 셀
final class SettingsNonIconButtonCell: SettingsViewCell {
    
    // MARK: - @IBOutlets
    
    /// 제목 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 버튼 이미지 뷰
    @IBOutlet weak var buttonImage: UIImageView!
    

    // MARK: - Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.attributedText = nil
        self.titleLabel.text = nil
    }
}
