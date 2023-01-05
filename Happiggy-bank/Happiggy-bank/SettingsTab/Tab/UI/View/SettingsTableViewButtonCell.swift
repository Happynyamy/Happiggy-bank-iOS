//
//  SettingsTableViewButtonCell.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/01.
//

import UIKit

/// 환결설정에서 사용하는 우측에 버튼이 있는 테이블뷰 셀
final class SettingsTableViewButtonCell: SettingsTableViewCell {

    // MARK: - Properties

    /// 셀 우측에 나타나는 버튼의 제목
    var buttonTitle: String? {
        get { self.buttonTitleLabel.text }
        set { self.buttonTitleLabel.text = newValue }
    }

    /// 셀 우측에 나타나는 버튼 제목의 색상
    var buttonTextColor: UIColor? {
        get { self.buttonTitleLabel.textColor }
        set { self.buttonTitleLabel.textColor = newValue }
    }

    /// 셀 우측에 나타나는 버튼의 이미지
    var buttonImage: UIImage? {
        get { self.buttonImageView.image }
        set {
            self.buttonImageView.image = newValue
            self.buttonImageView.isHidden = newValue == nil
        }
    }

    /// 셀 우측에 나타나는 버튼의 이미지 색상
    var buttonImageColor: UIColor? {
        get { self.buttonImageView.tintColor }
        set { self.buttonImageView.tintColor = newValue }
    }

    private let buttonStackView = UIStackView().then {
        $0.spacing = Metric.spacing
    }

    private let buttonTitleLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body4)
    }

    private let buttonImageView = UIImageView().then {
        $0.isHidden = true
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.width.equalTo(Metric.buttonWidth) }
    }


    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.buttonTitle = nil
        self.buttonImage = nil
        self.buttonTextColor = .label
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


    // MARK: - Configuration Functions

    private func configureViews() {
        self.configureSubviews()
    }

    private func configureSubviews() {
        self.contentStackView.addArrangedSubview(self.buttonStackView)
        self.buttonStackView.addArrangedSubviews(self.buttonTitleLabel, buttonImageView)
    }
}


// MARK: - Constants
fileprivate extension SettingsTableViewButtonCell {

    enum Metric {
        static let spacing: CGFloat = 8
        static let buttonWidth: CGFloat = 18
    }
}
