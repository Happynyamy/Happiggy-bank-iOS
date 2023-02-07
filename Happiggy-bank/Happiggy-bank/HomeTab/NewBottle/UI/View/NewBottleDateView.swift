//
//  NewBottleDateView.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/07.
//

import UIKit

import SnapKit
import Then

class NewBottleDateView: UIView {
    
    // MARK: - Properties
    
    lazy var mainLabel: BaseLabel = BaseLabel().then {
        $0.text = Text.mainLabel
        $0.textColor = AssetColor.mainYellow
        $0.changeFontSize(to: FontSize.body2)
    }
    
    lazy var descriptionLabel: BaseLabel = BaseLabel().then {
        $0.text = Text.descriptionLabel
        $0.textColor = AssetColor.mainGreen
        $0.changeFontSize(to: FontSize.body4)
    }
    
    lazy var pickerView: UIPickerView = UIPickerView()

    
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
    
    
    // MARK: - configuration functions
    
    private func configureSubviewsLayout() {
        self.addSubviews([
            self.mainLabel,
            self.descriptionLabel,
            self.pickerView
        ])
        
        self.pickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Metric.mainLabelTop)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pickerView.snp.bottom).offset(Metric.descriptionLabelTop)
        }
    }
}

extension NewBottleDateView {
    
    enum Text {
        
        static let mainLabel: String = "저금통 기간을 선택해주세요"
        
        static let descriptionLabel: String = "개봉일: yyyy년 mm월 dd일"
    }
    
    enum Metric {
        
        static let mainLabelTop: CGFloat = UIScreen.main.bounds.height * mainLabelTopRatio
        
        static let descriptionLabelTop: CGFloat = 40
        
        static let pickerViewTop: CGFloat = 40
        
        static private let mainLabelTopRatio: CGFloat = 220 / 852
    }
}
