//
//  SettingsViewCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/26.
//

import UIKit

import Then

/// 환경 설정 뷰에서 사용하는 셀로 이를 상속해서 각 행에 들어갈 셀 생성
class SettingsViewCell: UITableViewCell {
    
    // MARK: Properties
    private var isConfigured = false
    
    
    // MARK: - Override Functions

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.configureContentViewInset()
        self.configreSeperator()
    }
    
    
    // MARK: - Functions
    
    /// 상하좌우 마진 설정
    private func configureContentViewInset() {
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: .zero,
                left: Metric.HorizontalPadding,
                bottom: .zero,
                right: Metric.HorizontalPadding
            )
        )
    }
    
    /// 구분선 생성
    private func configreSeperator() {
        let seperator = UIView().then {
            $0.backgroundColor = .customLightGray
        }
        
        seperator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(seperator)
        
        NSLayoutConstraint.activate([
            seperator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            seperator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            seperator.heightAnchor.constraint(equalToConstant: .one)
        ])
    }
}
