//
//  ColorButton.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

/// NewNoteColorPicker 에서 사용되는 버튼으로,  선택 가능한 쪽지 색상을 나타냄
final class ColorButton: UIControl {
    
    // MARK: - @IBOutlet
    
    /// 버튼이 선택된 경우 외곽선을 강조 표시하기 위한 뷰
    @IBOutlet var highlightView: UIView!
    
    /// 색깔 버튼
    @IBOutlet var button: UIButton!
    
    
    // MARK: - Properties
    
    /// 버튼의 색깔
    var color: NoteColor!

    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    
    // MARK: - @IBAction
    
    /// 버튼을 눌렀을 때 호출되는 메서드 : 자신이 선택되었음을 전달
    @IBAction func buttonDidTap(_ sender: UIButton) {
        self.sendActions(for: .valueChanged)
    }
    
    
    // MARK: - Functions
    
    /// 버튼 상태 초기 설젛
    func initialSetup(isSelected: Bool) {
        self.button.backgroundColor = UIColor.note(color: self.color)
        self.updateState(isSelected: isSelected)
    }
    
    /// 선택 여부에 따라 모습 업데이트
    func updateState(isSelected: Bool) {
        /// 선택된 경우 하이라이트 효과 나타냄
        if isSelected {
            UIView.animate(withDuration: Metric.animationDuration) {
                self.highlightView.backgroundColor = .highlight(color: self.color)
                self.button.layer.borderColor = UIColor.highlight(color: self.color).cgColor
            }
            return
        }
        /// 선택되지 않은 경우 하이라이트 효과를 끔
        if !isSelected {
            self.highlightView.backgroundColor = .clear
            if self.color != NoteColor.white {
                self.button.layer.borderColor = UIColor.clear.cgColor
            }
            if self.color == NoteColor.white {
                self.button.layer.borderColor = Color.whiteButtonBorder.cgColor
            }
        }
    }
    
    /// 뷰 초기 모양 설정 및 뷰 체계 설정
    private func commonInit() {
        Bundle.main.loadNibNamed(ColorButton.name, owner: self, options: nil)
        self.addSubview(self.highlightView)
        self.highlightView.frame = self.bounds
        self.highlightView.layer.cornerRadius = Metric.highlightViewCornerRadius
        self.highlightView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.button.layer.cornerRadius = Metric.buttonCornerRadius
        self.button.layer.borderWidth = Metric.borderWidth
    }
}
