//
//  NotificationToggleCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/26.
//

import UIKit

// TODO: 리팩토링 완료 후 제거
/// 환경 설정 뷰 중 토글 스위치가 있는 항목을 위한 셀
final class NotificationToggleCell: SettingsViewCell {
    
    // MARK: - @IBOutlets
    
    /// 제목 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 토글 버튼
    @IBOutlet weak var toggleButton: UISwitch!
    
    /// 타임 피커
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
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
        super.prepareForReuse()
        
        self.titleLabel.text = .empty
        self.toggleButton.isOn = false
        self.timePicker.isHidden = true
    }
}
