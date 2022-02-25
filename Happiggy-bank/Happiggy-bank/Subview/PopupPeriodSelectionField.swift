//
//  PopupPeriodSelectionField.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/25.
//

import UIKit

import Then

/// 기간 선택 필드 뷰
final class PopupPeriodSelectionField: UIView {
    
    /// 기간 선택 필드 라벨
    let descriptionLabel = UILabel().then {
        $0.text = "유리병 개봉 기간"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 기간 선택 버튼 배열
    var periodButtons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureButtons()
        addComponents()
        setInnerConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureButtons()
        addComponents()
        setInnerConstraints()
    }
    
    /// 기간 선택 필드 뷰 설정
    private func configureView() {
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.viewWidth,
            height: Metric.viewHeight
        )
    }
    
    /// 기간 선택 버튼 설정
    private func configureButtons() {
        let buttonCount = 5
        let buttonTitles = ["1주", "1달", "3달", "6달", "1년"]
        
        for index in 0..<buttonCount {
            let button = UIButton().then {
                $0.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: Metric.buttonWidth,
                    height: Metric.buttonHeight
                )
                $0.layer.cornerRadius = 10
                $0.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
                $0.layer.borderWidth = 1.0
                $0.setTitle(buttonTitles[index], for: .normal)
                $0.setTitleColor(UIColor(hex: 0x777777), for: .normal)
                $0.setTitleColor(UIColor(hex: 0xFFFFFF), for: .selected)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            self.periodButtons.append(button)
        }
    }
    
    /// 기간 선택 필드 하위 뷰 추가
    private func addComponents() {
        self.addSubview(descriptionLabel)
        for button in periodButtons {
            self.addSubview(button)
        }
    }
    
    /// 기간 선택 필드 하위 뷰 Constraints
    private func setInnerConstraints() {
        
        // description Label
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(
                equalTo: self.topAnchor
            ),
            self.descriptionLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            )
        ])
        
        // period Buttons
        
        for (index, button) in periodButtons.enumerated() {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(
                    equalToConstant: Metric.buttonWidth
                ),
                button.heightAnchor.constraint(
                    equalToConstant: Metric.buttonHeight
                ),
                button.topAnchor.constraint(
                    equalTo: self.descriptionLabel.bottomAnchor,
                    constant: Metric.innerPadding
                )
            ])
            
            if index == 0 {
                button.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor
                ).isActive = true
            } else {
                button.leadingAnchor.constraint(
                    equalTo: periodButtons[index - 1].trailingAnchor,
                    constant: Metric.buttonPadding
                ).isActive = true
            }
        }
    }
}
