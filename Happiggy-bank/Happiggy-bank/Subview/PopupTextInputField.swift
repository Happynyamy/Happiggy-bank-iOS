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
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 이름 입력 텍스트필드
    let textField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력하세요.",
            attributes: [
                .foregroundColor: UIColor(hex: 0xECA7A7),
                .font: UIFont.systemFont(ofSize: 18)
            ])
        $0.backgroundColor = UIColor(hex: 0xFFF9F9)
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 유리병 이름 입력 필드 설정
    private func configureView() {
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: PopupTextInputField.Metric.viewWidth - 48,
            height: 90
        )
    }
    
    /// 유리병 이름 입력 필드 하위 뷰 추가
    private func addComponents() {
        self.addSubview(descriptionLabel)
        self.addSubview(textField)
    }
}
