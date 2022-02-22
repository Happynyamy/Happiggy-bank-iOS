//
//  ColorPalette.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/24.
//

import UIKit

import Then

/// note 추가 팝업 하단의 컬러 팔레트
final class ColorPalette: UIControl {
    
    // MARK: - Properties
    
    /// 컬러 버튼들이 담긴 스택 뷰(팔레트)
    lazy var stackView = UIStackView().then {
        $0.frame = self.bounds
        $0.distribution = .equalSpacing
    }
    
    /// 팔레트에서 선택된 버튼의 색상
    lazy private(set) var selectedColor: UIColor = {
        self.colorButtons.first?.backgroundColor ?? .noteDefault
    }()
    
    /// 컬러버튼들의 배열
    private var colorButtons = [ColorButton]()
    
    /// 선택된 컬러 버튼을 표시하기 위한 효과를 나타내는 뷰
    private let highlightView = UIView().then {
        $0.frame = CGRect(origin: .zero, size: Metric.highlightViewSize)
        $0.layer.cornerRadius = Metric.highlightViewCornerRadius
        $0.layer.borderWidth = Metric.highlightBorderWidth
    }
    
    /// 하이라이트 뷰의 center x anchor constraint 로 선택 버튼 변화에 따라 constraint 를 업데이트하기 위해 필요
    private var highlightViewXConstraint: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            highlightViewXConstraint.isActive = true
        }
    }
    
    /// 선택된 color button 의 인덱스
    /// 인덱스가 변경되면 하이라이트 뷰의 위치를 업데이트함
    private var selectedIndex = 0 {
        didSet {
            updateHighlightView()
        }
    }
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViewHierarchy()
        configureConstraints()
    }
    
    convenience init(colors: [UIColor]) {
        self.init(frame: .zero)
        
        configureColorButtons(from: colors)
        configureViewHierarchy()
        configureConstraints()
    }
    
    
    // MARK: - @objc
    
    /// 컬러 버튼을 누르면 호출되는 메서드
    @objc private func colorButtonDidTap(_ sender: ColorButton) {
        guard let buttonIndex = colorButtons.firstIndex(of: sender),
              buttonIndex >= 0,
              buttonIndex < colorButtons.count
        else { return }
        if self.selectedIndex != buttonIndex {
            updateNewSelection(index: buttonIndex, color: sender.backgroundColor)
        }
    }
    
    
    // MARK: - functions
    
    /// 주어진 색상에 맞는 컬러 버튼들을 생성해서 color buttons 배열에 추가
    private func configureColorButtons(from colors: [UIColor]) {
        colors.forEach {
            let button = ColorButton($0)
            button.addTarget(
                self,
                action: #selector(self.colorButtonDidTap(_:)),
                for: .touchUpInside
            )
            self.colorButtons.append(button)
        }
    }
    
    /// 뷰 체계 설정
    private func configureViewHierarchy() {
        self.addSubview(stackView)
        self.addSubview(highlightView)
        self.colorButtons.forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// 뷰들의 오토레이아웃 설정
    private func configureConstraints() {
        configureStackViewConstraints()
        configureHighlghtViewConstraints()
        configureColorButtonConstraints()
    }
    
    /// stack view(팔레트)의 오토레이아웃 설정
    private func configureStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    /// 하이라이트뷰의 오토레이아웃 설정
    private func configureHighlghtViewConstraints() {
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            highlightView.widthAnchor.constraint(equalToConstant: Metric.highlightViewSize.width),
            highlightView.heightAnchor.constraint(
                equalToConstant: Metric.highlightViewSize.height
            ),
            highlightView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
        
        if let firstColorButton = colorButtons.first {
            self.highlightViewXConstraint = self.highlightView.centerXAnchor.constraint(
                equalTo: firstColorButton.centerXAnchor
            )
        }
    }
    
    /// 컬러 버튼들의 오토레이아웃 설정
    private func configureColorButtonConstraints() {
        self.colorButtons.forEach {
            let widthConstraint = $0.widthAnchor.constraint(
                equalToConstant: Metric.buttonSize.width
            )
            widthConstraint.isActive = true
        }
    }
    
    /// 선택된 색상이 바뀌면 selected color 변수와 selected index 변수를 업데이트해 팔레트가 이를 반영할 수 있도록 하고,
    /// 뷰 컨트롤러에 색상이 바뀌었음을 알림
    private func updateNewSelection(index: Int, color: UIColor?) {
        self.selectedColor = color ?? .noteDefault
        
        let selectionAnimator = UIViewPropertyAnimator(
            duration: 0.3,
            dampingRatio: 0.9) {
                self.selectedIndex = index
                self.layoutIfNeeded()
            }
        selectionAnimator.startAnimation()
        self.sendActions(for: .valueChanged)
    }
    
    /// 선택된 컬러 버튼이 바뀌면 하이라이트 뷰의 색깔과 위치를 그에 맞게 업데이트
    private func updateHighlightView() {
        self.highlightView.layer.borderColor = UIColor.highlightColor(for: selectedColor).cgColor
        let button = colorButtons[selectedIndex]
        self.highlightViewXConstraint = highlightView.centerXAnchor.constraint(
            equalTo: button.centerXAnchor
        )
    }
}
