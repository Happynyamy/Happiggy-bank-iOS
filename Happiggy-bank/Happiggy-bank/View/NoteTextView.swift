//
//  NoteTextView.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/27.
//

import UIKit

/// 쪽지 내용을 입력받는 text view
final class NoteTextView: UITextView {
    
    // MARK: - Properties
    
    /// placeholder 의 역할을 대신 할 label
    lazy var placeholder = UILabel().then {
        $0.text = StringLiteral.noteTextViewPlaceHolder
        $0.textColor = .lightGray
        $0.font = Font.body
        $0.numberOfLines = 0
        if !self.text.isEmpty { $0.isHidden = true }
    }
    
    /// 현재까지 작성한 note 의 글자수를 세는 label
    lazy var letterCountLabel = UILabel().then {
        $0.text = StringLiteral.letterCountLabel
        $0.font = Font.body
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init() {
        self.init(frame: .zero, textContainer: nil)
        
        self.textContainerInset = UIEdgeInsets(
            top: Metric.horizontalPadding,
            left: Metric.verticalPadding,
            bottom: Metric.horizontalPadding,
            right: Metric.verticalPadding
        )
        self.font = Font.body
        configureViewHierarchy()
        configureConstraints()
    }
    
    
    // MARK: - Functions
    
    /// 뷰 체계 설정
    private func configureViewHierarchy() {
        self.addSubview(placeholder)
        self.addSubview(letterCountLabel)
    }
    
    /// 뷰들의 오토레이아웃 설정
    private func configureConstraints() {
        configurePlaceHolderConstraints()
        configureLetterCountLabelConstraints()
    }
    
    /// 플레이스홀더의 오토레이아웃 설정
    private func configurePlaceHolderConstraints() {
        self.placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.placeholder.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Metric.horizontalPadding
            ),
            self.placeholder.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Metric.verticalPadding
            )
        ])
    }
    
    /// 글자수 라벨의 오토레이아웃 설정
    private func configureLetterCountLabelConstraints() {
        self.letterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.letterCountLabel.trailingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Metric.letterCountLabelTrailingConstant
            ),
            self.letterCountLabel.bottomAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Metric.letterCountLabelBottomConstant
            )
        ])
    }
}
