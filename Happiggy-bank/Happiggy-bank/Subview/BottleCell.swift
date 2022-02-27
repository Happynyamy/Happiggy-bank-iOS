//
//  BottleCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit

import Then

/// 유리병 리스트의 셀
class BottleCell: UITableViewCell {
    
    // MARK: Properties
    // TODO: 이미지로 교체
    /// 배경
    let background = UIView().then {
        $0.frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.cellBackgroundWidth,
            height: Metric.cellBackgroundHeight
        )
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 제목 라벨
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: FontSize.titleLabel, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 기간 라벨
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: FontSize.dateLabel)
        $0.textColor = UIColor(hex: Color.dateLabelText)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: override func
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureViewHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: cell settings
    
    /// 셀 속성 설정
    private func configureCell() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hex: BottleListViewController.Color.tableViewBackground)
    }
    
    
    // MARK: View Hierarchy
    
    /// 뷰 계층 설정
    private func configureViewHierarchy() {
        self.addSubview(background)
        self.background.addSubview(titleLabel)
        self.background.addSubview(dateLabel)
    }
    
    
    // MARK: Constraints
    
    /// Constraints 메서드 호출하는 함수
    private func configureConstraints() {
        configureBackgroundConstraints()
        configureTitleLabelConstraints()
        configureDateLabelConstraints()
    }
    
    /// 배경 Constraints 설정
    private func configureBackgroundConstraints() {
        NSLayoutConstraint.activate([
            self.background.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Metric.cellVerticalPadding
            ),
            self.background.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -Metric.cellVerticalPadding
            ),
            self.background.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Metric.cellHorizontalPadding
            ),
            self.background.widthAnchor.constraint(
                equalToConstant: Metric.cellBackgroundWidth
            ),
            self.background.heightAnchor.constraint(
                equalToConstant: Metric.cellBackgroundHeight
            )
        ])
    }
    
    /// 유리병 제목 라벨 Constraints 설정
    private func configureTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(
                equalTo: self.background.leadingAnchor,
                constant: Metric.cellInnerLeadingPadding
            ),
            self.titleLabel.trailingAnchor.constraint(
                equalTo: self.background.trailingAnchor,
                constant: -Metric.cellInnerTrailingPadding
            ),
            self.titleLabel.topAnchor.constraint(
                equalTo: self.background.topAnchor,
                constant: Metric.cellInnerVerticalPadding
            )
        ])
    }
    
    /// 유리병 기간 라벨 Constraints 설정
    private func configureDateLabelConstraints() {
        NSLayoutConstraint.activate([
            self.dateLabel.leadingAnchor.constraint(
                equalTo: self.background.leadingAnchor,
                constant: Metric.cellInnerLeadingPadding
            ),
            self.dateLabel.trailingAnchor.constraint(
                equalTo: self.background.trailingAnchor,
                constant: -Metric.cellInnerTrailingPadding
            ),
            self.dateLabel.topAnchor.constraint(
                equalTo: self.titleLabel.bottomAnchor,
                constant: Metric.cellLabelPadding
            ),
            self.dateLabel.bottomAnchor.constraint(
                equalTo: self.background.bottomAnchor,
                constant: -Metric.cellInnerVerticalPadding
            )
        ])
    }
}
