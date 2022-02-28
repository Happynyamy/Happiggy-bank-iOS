//
//  PopupTextInputField.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/25.
//

import UIKit

import Then

/// 유리병 이름 입력 필드 뷰
final class PopupTextInputField: UIView {
    
    /// 유리병 이름 입력 필드 라벨
    let descriptionLabel = UILabel().then {
        $0.text = "유리병 이름"
        $0.font = .systemFont(ofSize: FontSize.descriptionLabel, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 이름 입력 텍스트필드
    let textField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력하세요.",
            attributes: [
                .foregroundColor: UIColor(hex: Color.placeHolder),
                .font: UIFont.systemFont(ofSize: FontSize.placeHolder)
            ])
        $0.backgroundColor = UIColor(hex: Color.textFieldBackground)
        $0.leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 15,
                height: Metric.textFieldHeight
            ))
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addComponents()
        setInnerConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        addComponents()
        setInnerConstraints()
    }
    
    /// 유리병 이름 입력 필드 설정
    private func configureView() {
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.viewWidth,
            height: Metric.viewHeight
        )
    }
    
    /// 유리병 이름 입력 필드 하위 뷰 추가
    private func addComponents() {
        self.addSubview(descriptionLabel)
        self.addSubview(textField)
    }
    
    private func setInnerConstraints() {
        // Text Input Field's description Label
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(
                equalTo: self.topAnchor
            ),
            self.descriptionLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            )
        ])
        
        // Text Input Field's textField
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(
                equalTo: self.descriptionLabel.bottomAnchor,
                constant: Metric.innerPadding
            ),
            self.textField.widthAnchor.constraint(
                equalTo: self.widthAnchor
            ),
            self.textField.heightAnchor.constraint(
                equalToConstant: Metric.textFieldHeight
            )
        ])
    }
}
