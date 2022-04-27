//
//  SettingsToggleButtonCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/26.
//

import UIKit

/// 환경 설정 뷰 중 토글 스위치가 있는 항목을 위한 셀
final class SettingsToggleButtonCell: SettingsViewCell {
    
    // MARK: - @IBOutlets
    
    /// 제목 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = .empty
    }
}
