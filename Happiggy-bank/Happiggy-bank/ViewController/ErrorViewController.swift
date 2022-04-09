//
//  ErrorViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/09.
//

import UIKit

/// 코어데이터 로딩 오류 발생 시 나타나는 뷰 컨트롤러
final class ErrorViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.configureInformationLabel()
    }
    
    
    // MARK: - @objc
    
    /// 유저가 화면을 탭하면 강제 종료
    @objc private func userDidTap(sender: UITapGestureRecognizer) {
        fatalError(StringLiteral.errorDescription)
    }
    
    
    // MARK: - Functions
    
    /// 에러 안내 라벨 생성
    private func configureInformationLabel() {
        
        let informationLabel = UILabel().then {
            $0.textColor = .customWarningLabel
            $0.numberOfLines = .zero
            $0.textAlignment = .center
            $0.text = StringLiteral.informationLabelText
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        self.view.addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            informationLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(userDidTap(sender:))
        ))
    }
}
