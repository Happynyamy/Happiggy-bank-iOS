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
    
    /// 제목 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 버튼 역할을 하는 스택
    @IBOutlet weak var buttonStack: UIStackView!
    
    /// 버튼 스택의 정보 라벨
    @IBOutlet weak var informationLabel: UILabel!
    
    /// 버튼 이미지 뷰
    @IBOutlet weak var buttonImageView: UIImageView!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGestureRecognizer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 버튼 스택에 tap gesture recognizer 추가
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(buttonStackDidTap(sender:))
        )
        self.buttonStack.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 버튼 스택을 탭하면 호출되는 메서드
    @objc private func buttonStackDidTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("show appstore")
        }
    }
}
