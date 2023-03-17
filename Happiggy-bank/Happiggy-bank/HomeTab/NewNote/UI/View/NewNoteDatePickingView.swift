//
//  NewNoteDatePickingView.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/17.
//

import UIKit

final class NewNoteDatePickingView: UIView {

    // MARK: - Properties

    let datePicker = UIPickerView()

    let warningLabel = BaseLabel().then {
        $0.text = StringLiteral.warning
        $0.textColor = AssetColor.etcAlert
        $0.changeFontSize(to: FontSize.body4)
        $0.isHidden = true
    }

    private let instructionLabel = BaseLabel().then {
        $0.text = StringLiteral.instruction
        $0.textColor = AssetColor.mainYellow
        $0.changeFontSize(to: FontSize.body2)
    }


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureViews()
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.configureSubviews()
        self.configureConstraints()
    }

    private func configureSubviews() {
        self.addSubviews(self.instructionLabel, self.datePicker, self.warningLabel)
        self.configureSelectionIndicator()
    }

    /// 날짜 피커의 셀렉션 인디케이터를 흰색으로 변경
    private func configureSelectionIndicator() {
        self.datePicker.layoutIfNeeded()
        /// 기존 인디케이터 투명 처리
        guard let formerSelectionIndicator = self.datePicker.subviews[safe: 1]
        else {
            return
        }

        formerSelectionIndicator.backgroundColor = .clear

        /// 흰색의 새로운 인디케이터 생성
        let newSelectionIndictor = UIView().then {
            $0.frame = formerSelectionIndicator.frame
            $0.layer.cornerRadius = formerSelectionIndicator.layer.cornerRadius
            $0.backgroundColor = .systemBackground
        }

        /// 뷰 체계에 삽입 및 오토 레이아웃 설정
        self.insertSubview(newSelectionIndictor, belowSubview: self.datePicker)
        newSelectionIndictor.snp.makeConstraints {
            $0.center.size.equalTo(formerSelectionIndicator)
        }
    }

    private func configureConstraints() {
        self.datePicker.snp.makeConstraints { $0.center.equalToSuperview() }
        self.instructionLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.datePicker)
            $0.bottom.equalTo(self.datePicker.snp.top).offset(-Metric.spacing45)
        }
        self.warningLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.datePicker)
            $0.top.equalTo(self.datePicker.snp.bottom).offset(Metric.spacing45)
        }
    }
}


// MARK: - Constants
fileprivate extension NewNoteDatePickingView {

    enum Metric {
        static let spacing45: CGFloat = 45
    }

    enum StringLiteral {
        static let instruction = "작성 날짜를 선택해 주세요"
        static let warning = "해당 날짜에는 이미 쪽지를 작성했어요!"
    }
}
