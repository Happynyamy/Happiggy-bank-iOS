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
    private let lineColor: UIColor?


    // MARK: - Init

    init(color: NoteColor, frame: CGRect = .zero) {
        self.color = color
        self.lineColor = AssetColor.noteLine(for: self.color)
        super.init(frame: frame)

        self.tintColor = AssetColor.noteText(for: self.color)
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
        let isLightMode = self.traitCollection.userInterfaceStyle == .light

        /// 선택된 경우 하이라이트 효과 나타냄
        if self.isSelected {
            self.layer.borderWidth = Metric.borderWidth
            let tintColor = isLightMode ? self.tintColor.cgColor : UIColor.white.cgColor
            self.layer.borderColor = tintColor
            return
        }
        /// 선택되지 않은 경우 하이라이트 효과를 끔
        if !self.isSelected {
            if isLightMode, self.color == .white {
                self.layer.borderColor = self.lineColor?.cgColor
                return
            }
            self.layer.borderWidth = .zero
        }
    }

    /// 뷰 초기화
    private func configure() {
        self.backgroundColor = AssetColor.noteBG(for: self.color)
        self.layer.cornerRadius = Metric.buttonCornerRadius
    }
}
