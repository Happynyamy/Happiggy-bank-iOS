//
//  ColorPicker.swift
//  Happiggy-bank
//
//  Created by sun on 2022/10/20.
//

import UIKit

/// 색깔을 고를 수 있는 컬러 피커
final class ColorPicker: UIStackView {

    // MARK: - Properties

    weak var delegate: ColorPickerDelegate?

    /// 현재 선택된 색깔
    private(set) var selectedColor = NoteColor.allCases.first ?? .white

    /// 색깔 버튼들
    private lazy var colorButtons : [ColorButton] = NoteColor.allCases.map { color in
        ColorButton(color: color).then {
            let isSelected = color == self.selectedColor
            $0.isSelected = isSelected
        }
    }


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configure()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        self.configure()
    }


    // MARK: - Configuration Functions

    /// 뷰 초기화
    private func configure() {
        self.spacing = Metric.spacing
        self.colorButtons.forEach { self.addArrangedSubview($0) }
        self.configureColorButtons()
    }

    /// 색상 버튼에 액션 추가 및 하위 뷰로 추가
    private func configureColorButtons() {
        let action = UIAction { [weak self] in
            guard let button = $0.sender as? ColorButton,
                  button.color != self?.selectedColor
            else { return }

            self?.selectedColor = button.color
            self?.delegate?.selectedColorDidChange(to: button.color)
            self?.colorButtons.forEach {
                $0.isSelected = $0 == button
            }
        }
        self.colorButtons.forEach {
            $0.addAction(action, for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: Metric.buttonWidth),
                $0.heightAnchor.constraint(equalToConstant: Metric.buttonHeight)
            ])
        }
    }
}


// MARK: - Constants

fileprivate extension ColorPicker {

    /// 상수
    enum Metric {

        /// 간격: 16
        static let spacing: CGFloat = 16

        /// 컬러버튼 너비
        static let buttonWidth: CGFloat = 28

        /// 컬러버튼 높이
        static let buttonHeight = buttonWidth
    }
}
