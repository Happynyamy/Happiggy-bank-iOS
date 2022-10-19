//
//  ColorButton.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

/// 특정 색상을 나타내는 버튼
final class ColorButton: UIButton {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet { self.updateState() }
    }

    /// 쪽지 색상 
    let color: NoteColor

    /// 버튼의 테두리 색깔
    private let borderColor: CGColor?


    // MARK: - Init

    init(color: NoteColor, frame: CGRect = .zero) {
        self.color = color
        self.borderColor = UIColor.noteBorder(for: self.color).cgColor
        super.init(frame: frame)

        self.tintColor = .noteHighlight(for: self.color)
        self.configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Functions

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    /// 선택 여부에 따라 모습 업데이트
    private func updateState() {
        /// 선택된 경우 하이라이트 효과 나타냄
        if self.isSelected {
            UIView.animate(withDuration: Metric.animationDuration) {
                self.layer.borderColor = self.tintColor.cgColor
            }
            return
        }
        /// 선택되지 않은 경우 하이라이트 효과를 끔
        if !self.isSelected {
            self.layer.borderColor = self.borderColor
        }
    }

    /// 뷰 초기화
    private func configure() {
        self.backgroundColor = .note(color: self.color)
        self.layer.borderWidth = Metric.borderWidth
        self.layer.cornerRadius = Metric.buttonCornerRadius
    }
}
