//
//  NoteCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

/// 쪽지 리스트에서 사용할 셀
final class NoteCell: UITableViewCell {
    
    // MARK: - @IBOulet
    
    /// 색깔에 따라 쪽지 이미지 혹은 배경색을 변경할 뷰
    @IBOutlet var noteImageView: UIImageView!
    
    /// 앞면(미개봉) 날짜 라벨
    @IBOutlet weak var frontDateLabel: UILabel!
    
    /// 뒷면(개봉) 날짜 라벨
    @IBOutlet weak var backDateLabel: UILabel!
    
    /// 뒷면에 나타날 쪽지 내용
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            self.contentLabel.configureParagraphStyle(
                lineSpacing: Metric.lineSpacing,
                characterSpacing: Metric.characterSpacing
            )
        }
    }
    
    /// 애니메이션 딜레이 시간: 디폴트 0
    var animationDelay: TimeInterval = .zero
    
    /// 애니메이션 후 실행할 작업
    var completion: ((Bool) -> Void)?
    
    
    // MARK: - Function
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.contentView.frame.inset(
            by: UIEdgeInsets(
                top: .zero,
                left: Metric.horizontalPadding,
                bottom: .zero,
                right: Metric.horizontalPadding
            )
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected
        else { return }
        
        self.updateLabelStates()
        self.animateLabelStateUpdates()
    }
    
    /// (선택된 경우에 호출하는 메서드로) 내용 라벨과 뒷면 날짜 라벨을 나타내고, 앞면 날짜 라벨을 숨김 처리
    private func updateLabelStates() {
        self.frontDateLabel.isHidden = true
        self.contentLabel.isHidden = false
        self.backDateLabel.isHidden = false
    }
    
    /// (선택된 경우에 호출하는 메서드로) 날짜 라벨이 이동하면 내용 라벨이 페이드인하는 효과를 나타냄
    private func animateLabelStateUpdates() {
        /// 페이드 인 효과를 위해 투명도 0으로 설정
        self.contentLabel.alpha = .zero
        /// 이동 효과 주기 위해 프레임을 가운데로 변경
        self.backDateLabel.frame = self.frontDateLabel.frame

        UIView.animateKeyframes(
            withDuration: Metric.animationDuration,
            delay: self.animationDelay
        ) {
            /// 날짜 라벨 이동 애니메이션
            UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: Metric.half) {
                self.layoutIfNeeded()
            }
            /// 내용 라벨 페이드 인 애니메이션
            UIView.addKeyframe(withRelativeStartTime: Metric.half, relativeDuration: Metric.half) {
                self.contentLabel.alpha = .one
            }
        } completion: { result in
            guard let completion = self.completion else {
                return
            }
            
            completion(result)
        }
    }
}
