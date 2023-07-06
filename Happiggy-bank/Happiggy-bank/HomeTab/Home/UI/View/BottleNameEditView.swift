//
//  BottleNameEditView.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/07/06.
//

import UIKit

import SnapKit
import Then

final class BottleNameEditView: UIView {

    // MARK: - Properties
    
    /// 메인 라벨(저금통을 입력해주세요)
    lazy var mainLabel: BaseLabel = BaseLabel().then {
        $0.text = Text.mainLabel
        $0.textColor = AssetColor.mainYellow
        $0.changeFontSize(to: FontSize.body2)
    }
    
    /// 설명 라벨(저금통은 나중에 변경할 수 있습니다)
    lazy var descriptionLabel: BaseLabel = BaseLabel().then {
        $0.text = Text.descriptionLabel
        $0.textColor = AssetColor.subBrown02
        $0.changeFontSize(to: FontSize.body4)
    }
    
    /// 경고 라벨(저금통 이름이 없어요!)
    lazy var warningLabel: BaseLabel = BaseLabel().then {
        $0.text = Text.warningLabel
        $0.textColor = AssetColor.etcAlert
        $0.changeFontSize(to: FontSize.body4)
        $0.isHidden = true
    }
    
    /// 저금통 이름 입력할 텍스트필드
    lazy var textField: BaseTextField = BaseTextField().then {
        $0.placeholder = Text.placeholder
        $0.layer.cornerRadius = Metric.cornerRadius
        $0.backgroundColor = .white
        $0.textAlignment = .center
    }
    
    
    // MARK: - override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = AssetColor.subGrayBG
        configureSubviewsLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - configurations
    
    /// 뷰의 자식 뷰들 레이아웃 설정
    private func configureSubviewsLayout() {
        self.addSubviews([
            self.mainLabel,
            self.descriptionLabel,
            self.warningLabel,
            self.textField
        ])
        
        self.mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Metric.mainLabelTop)
        }
        
        self.textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mainLabel.snp.bottom).offset(Metric.textFieldTop)
            make.height.equalTo(Metric.textFieldHeight)
            make.width.equalTo(self.textField.snp.height).multipliedBy(Metric.textFieldRatio)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.textField.snp.bottom).offset(Metric.descriptionLabelTop)
        }
        
        self.warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(Metric.warningLabelTop)
        }
    }
}

extension BottleNameEditView {
    enum Text {
        static let mainLabel: String = "저금통 이름을 입력해주세요"
        
        static let descriptionLabel: String = "저금통 이름은 나중에 변경할 수 있습니다"
        
        static let warningLabel: String = "저금통 이름이 없어요!"
        
        static let placeholder: String = "최대 10자까지 가능합니다"
    }
    
    enum Metric {
        static let cornerRadius: CGFloat = 7
        
        static let mainLabelTop: CGFloat = UIScreen.main.bounds.height * mainLabelTopRatio
        
        static let textFieldTop: CGFloat = 32
        
        static let descriptionLabelTop: CGFloat = 16
        
        static let warningLabelTop: CGFloat = 16
        
        static let textFieldHeight: CGFloat = 56
        
        static let textFieldRatio: CGFloat = 311 / 56
        
        static private let mainLabelTopRatio: CGFloat = 220 / 852
    }
}

