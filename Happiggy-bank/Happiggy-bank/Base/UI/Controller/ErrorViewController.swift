//
//  ErrorViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/09.
//

import UIKit

/// 코어데이터 로딩 오류 발생 시 나타나는 뷰 컨트롤러
final class ErrorViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 에러메시지
    private var errorMessage: String!
    
    /// 유저에게 에러와 메일 주소를 안내하는 라벨
    private var informationLabel: UILabel!
    
    /// 디버깅용 문구를 나타내는 텍스트뷰
    private var errorMessageTextView: UITextView!
    
    
    // MARK: - Inits
    
    init(errorMessage: String) {
        super.init(nibName: nil, bundle: nil)
        self.errorMessage = errorMessage
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.configureViewHierarchy()
    }
    
    
    // MARK: - @objc
    
    /// 유저가 화면을 탭하면 강제 종료
    @objc private func userDidTap(sender: UITapGestureRecognizer) {
        fatalError(StringLiteral.errorDescription)
    }
    
    
    // MARK: - Functions
    
    /// 뷰 초기설정
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(userDidTap(sender:))
        ))
        self.configureInformationLabel()
        self.configureErrorMessageTextView()
    }
    
    /// 에러 안내 라벨 생성
    private func configureInformationLabel() {
        
        self.informationLabel = UILabel().then {
            $0.textColor = .customWarningLabel
            $0.numberOfLines = .zero
            $0.textAlignment = .center
            $0.text = StringLiteral.informationLabelText
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// 텍스트뷰 초기 설정
    private func configureErrorMessageTextView() {
        self.errorMessageTextView = UITextView().then {
            $0.textColor = .label
            $0.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            $0.isEditable = false
            $0.showsHorizontalScrollIndicator = false
            $0.text = self.errorMessage
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// 뷰 체계 구성
    private func configureViewHierarchy() {
        self.view.addSubview(self.informationLabel)
        self.view.addSubview(self.errorMessageTextView)
        self.configureInformationLabelConstraints()
        self.configureErrorMessageTextViewConstraints()
    }
    
    /// 정보 라벨 오토레이아웃 설정
    private func configureInformationLabelConstraints() {
        NSLayoutConstraint.activate([
            self.informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.informationLabel.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: Metric.paddings.top
            )
        ])
    }
    
    /// 에러 메시지 텍스트뷰 오토레이아웃 설정
    private func configureErrorMessageTextViewConstraints() {
        NSLayoutConstraint.activate([
            self.errorMessageTextView.topAnchor.constraint(
                equalTo: self.informationLabel.bottomAnchor,
                constant: Metric.spacing
            ),
            self.errorMessageTextView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: Metric.paddings.bottom
            ),
            self.errorMessageTextView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Metric.paddings.leading
            ),
            self.errorMessageTextView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: Metric.paddings.trailing
            )
        ])
    }
}
