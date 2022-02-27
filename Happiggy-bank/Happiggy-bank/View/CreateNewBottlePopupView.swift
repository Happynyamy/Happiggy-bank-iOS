//
//  CreateNewBottlePopupView.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/23.
//

import UIKit

import Then

final class CreateNewBottlePopupView: UIView {
    
    /// 팝업 뷰의 상단 바
    lazy var topBar = PopupTopBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 팝업 뷰의 유리병 이름 입력 필드
    lazy var textInputField = PopupTextInputField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 팝업 뷰의 기간 선택 필드
    lazy var periodSelectionField = PopupPeriodSelectionField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 팝업 뷰의 제출 버튼
    lazy var submitButton = UIButton().then {
        $0.frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.submitButtonWidth,
            height: Metric.submitButtonHeight
        )
        $0.setTitle("유리병 만들기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setBackgroundColor(UIColor.black, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 팝업 뷰 설정
    private func configureView() {
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: Metric.viewWidth,
            height: Metric.viewHeight
        )
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
    }
    
    /// 팝업 뷰의 하위 뷰 추가
    private func addComponents() {
        self.addSubview(topBar)
        self.addSubview(textInputField)
        self.addSubview(periodSelectionField)
        self.addSubview(submitButton)
    }
}
