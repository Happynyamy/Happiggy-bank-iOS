//
//  NotificationSettingTableViewCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/07/26.
//

import UIKit

import SnapKit
import Then

final class NotificationSettingTableViewCell: UITableViewCell {
  
    private let cellContentView: UIView = UIView()
    
    var title: String? {
        get { self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    var time: Date? {
        get { self.timePicker.date }
        set { self.timePicker.date = newValue ?? Date() }
    }
    
    lazy var titleLabel: BaseLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body3)
    }
    
    lazy var timePicker: UIDatePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .compact
        $0.isHidden = true
    }
    
    lazy var toggleButton: UISwitch = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .customTint
    }
    
    private let contentAndSeparatorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let separator = UIView().then {
        $0.backgroundColor = AssetColor.etcBorderGray
        $0.snp.makeConstraints { make in
            make.height.equalTo(Metric.separatorHeight)
        }
    }
    
    // MARK: - Init(s)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        initializeLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.selectionStyle = .none
        initializeLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = .empty
        timePicker.isHidden = true
        toggleButton.isOn = false
    }
    
    private func initializeLayout() {
        self.contentView.addSubview(contentAndSeparatorStackView)
        self.cellContentView.addSubviews(titleLabel, toggleButton, timePicker)
        self.contentAndSeparatorStackView.addArrangedSubviews(cellContentView, separator)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.cellHorizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Metric.cellHorizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        timePicker.snp.makeConstraints { make in
            make.trailing.equalTo(toggleButton.snp.leading).offset(-Metric.cellHorizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        contentAndSeparatorStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Metric.inset)
        }
    }
}

extension NotificationSettingTableViewCell {
    enum Metric {
        static let separatorHeight: CGFloat = 1
        static let cellHorizontalPadding: CGFloat = 10
        static let inset: CGFloat = 24
    }
}
