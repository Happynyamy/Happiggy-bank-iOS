//
//  NewNotePopupTopBar.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/23.
//

import UIKit

import Then

/// note 추가 팝업의 상단 바
class NewNotePopupTopBar: UIStackView {
    
    // MARK: - Properties
    
    /// 취소 버튼
    lazy var cancelButton: UIButton = DefaultButton(title: StringLiteral.cancelButtonTitle)
    
    /// 팝업 이름 라벨
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = StringLiteral.title
        $0.font = Font.title
    }
    
    /// 저장 버튼
    lazy var saveButton: UIButton = DefaultButton(title: StringLiteral.saveButtonTitle)
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureViewHierarchy()
        self.configureConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configureViewHierarchy()
        self.configureConstraints()
    }
    
    
    // MARK: - Functions
    
    /// 뷰 체계 설정
    private func configureViewHierarchy() {
        self.addArrangedSubview(self.cancelButton)
        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(self.saveButton)
    }
    
    /// 뷰들의 오토 레이아웃 설정
    private func configureConstraints() {
        configureCancelButtonConstraints()
        configureTitleLabelConstraints()
        configureSaveButtonConstraints()
    }
    
    /// 취소버튼의 오토레이아웃 설정
    private func configureCancelButtonConstraints() {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.cancelButton.widthAnchor.constraint(equalToConstant: Metric.buttonSize.width)
        ])
    }
    
    /// 제목 라벨의 오토 레이아웃 설정
    private func configureTitleLabelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    /// 저장 버튼의 오토 레이아웃 설정
    private func configureSaveButtonConstraints() {
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.saveButton.widthAnchor.constraint(equalToConstant: Metric.buttonSize.width)
        ])
    }
}
