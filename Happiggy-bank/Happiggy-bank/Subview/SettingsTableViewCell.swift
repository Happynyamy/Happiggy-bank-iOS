//
//  SettingsTableViewCell.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/01.
//

import UIKit

import SnapKit
import Then

/// 환결성정의 각 항목을 나타내는 테이블뷰 셀로 아이콘과 항목 이름을 나타내는 레이블로 구성
class SettingsTableViewCell: UITableViewCell {

    // MARK: - Properties

    /// 아이콘 이미지뷰와 제목 레이블을 담고 있는 스택
    ///
    /// 새로운 버튼이나 레이블 등을 추가하고 싶으면 해당 스택에 추가
    let contentStackView = UIStackView()

    /// 셀 맨 좌측에 나타나는 아이콘
    var icon: UIImage? {
        get { self.iconView.image }
        set {
            self.iconView.image = newValue
            self.iconView.isHidden = newValue == nil
        }
    }

    /// 아이콘 바로 우측에 나타나는 제목
    var title: String? {
        get { self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }

    private let iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.snp.makeConstraints { $0.width.equalTo(Metric.iconSize) }
    }

    private let titleLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body3)
        $0.setContentHuggingPriority(.init(.zero), for: .horizontal)
    }

    private let iconAndTitleStackView = UIStackView().then {
        $0.spacing = Metric.spacing
    }

    private let contentAndSeparatorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let separator = UIView().then {
        $0.backgroundColor = AssetColor.etcBorderGray
        $0.snp.makeConstraints { $0.height.equalTo(Metric.separatorHeight)}
    }


    // MARK: - Init(s)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureViews()
    }


    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.title = nil
        self.icon = nil
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.selectionStyle = .none
        self.configureSubviews()
        self.configureConstraints()
    }

    private func configureSubviews() {
        self.contentView.addSubview(self.contentAndSeparatorStackView)
        self.contentAndSeparatorStackView.addArrangedSubviews(self.contentStackView, self.separator)
        self.contentStackView.addArrangedSubview(self.iconAndTitleStackView)
        self.iconAndTitleStackView.addArrangedSubviews(self.iconView, self.titleLabel)
    }

    private func configureConstraints() {
        self.contentAndSeparatorStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(Metric.inset)
        }
    }
}


// MARK: - Constants
fileprivate extension SettingsTableViewCell {

    enum Metric {
        static let inset: CGFloat = 24
        static let spacing: CGFloat = 16
        static let iconSize: CGFloat = 18
        static let separatorHeight: CGFloat = 1
        static let one: CGFloat = 1
    }
}
