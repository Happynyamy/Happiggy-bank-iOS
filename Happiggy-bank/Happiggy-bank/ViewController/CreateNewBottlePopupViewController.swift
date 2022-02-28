//
//  CreateNewBottlePopupViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/23.
//

import UIKit

/// 새로운 유리병을 생성하고 서버에 저장하는 뷰 컨트롤러
final class CreateNewBottlePopupViewController: UIViewController {
    
    // MARK: - properties
    
    /// 새 유리병 생성 팝업 뷰
    var createNewBottlePopupView: CreateNewBottlePopupView!
    
    /// 선택된 기간 버튼
    private var selectedPeriodButton: UIButton?
    
    
    // MARK: - view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackground()
        configurePopupView()
        addTargetToTopBarButton()
        addTargetToSelectionButtons()
        addTargetToSubmitButton()
        configureConstraints()
    }
    
    
    // MARK: - objc functions
    
    /// 취소 버튼을 눌렀을 때 발생하는 이벤트. 팝업 뷰가 닫힌다.
    @objc func dismissView(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    /// 기간 선택 필드의 각 버튼을 눌렀을 때 발생하는 이벤트. 선택됐을 때 색상이 바뀌고, 선택된 버튼을 업데이트한다.
    @objc func buttonSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.backgroundColor = UIColor(
                hex: PopupPeriodSelectionField.Color.buttonSelectedBackground
            )
            sender.layer.borderColor = UIColor.clear.cgColor
            if self.selectedPeriodButton != sender {
                self.selectedPeriodButton?.isSelected = false
                self.selectedPeriodButton?.backgroundColor = UIColor(
                    hex: PopupPeriodSelectionField.Color.buttonNormalBackground
                )
                self.selectedPeriodButton?.layer.borderColor = UIColor(
                    hex: PopupPeriodSelectionField.Color.buttonNormalBorder
                ).cgColor
            }
            self.selectedPeriodButton = sender
        } else {
            sender.backgroundColor = UIColor(
                hex: PopupPeriodSelectionField.Color.buttonNormalBackground
            )
            sender.layer.borderColor = UIColor(
                hex: PopupPeriodSelectionField.Color.buttonNormalBorder
            ).cgColor
            self.selectedPeriodButton = nil
        }
    }
    
    // TODO: - POST, Alert
    /// 팝업 뷰의 제출 버튼을 눌렀을 때 발생하는 이벤트. 서버에 해당 내용이 저장된다.
    @objc func submitNewBottleData(_ sender: UIButton) {
        print("submit datas")
        print("title: \(String(describing: createNewBottlePopupView.textInputField.textField.text))")
        print("period: \(String(describing: self.selectedPeriodButton?.titleLabel?.text))")
        self.dismiss(animated: false)
    }
    
    
    // MARK: - Configure Views
    
    /// 팝업 컨트롤러의 뷰를 투명한 검은색으로 만드는 함수. 팝업 뷰와 최근 뷰를 구분짓는다.
    private func configureBackground() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    /// 팝업 뷰를 구성하는 함수.
    private func configurePopupView() {
        createNewBottlePopupView = CreateNewBottlePopupView()
        self.view.addSubview(createNewBottlePopupView)
    }
    
    
    // MARK: - Event
    
    /// 팝업 뷰의 상단 바 버튼에 touchUpInside 액션을 추가하는 함수.
    private func addTargetToTopBarButton() {
        self.createNewBottlePopupView.topBar.cancelButton.addTarget(
            self,
            action: #selector(dismissView(_:)),
            for: .touchUpInside
        )
    }
    
    /// 팝업 뷰의 기간 선택 필드 버튼에 touchUpInside 액션을 추가하는 함수.
    private func addTargetToSelectionButtons() {
        let buttons = createNewBottlePopupView.periodSelectionField.periodButtons
        
        for button in buttons {
            button.addTarget(
                self,
                action: #selector(buttonSelected(_:)),
                for: .touchUpInside
            )
        }
    }
    
    /// 팝업 뷰의 제출 버튼에 touchUpInside 액션을 추가하는 함수.
    private func addTargetToSubmitButton() {
        self.createNewBottlePopupView.submitButton.addTarget(
            self,
            action: #selector(submitNewBottleData(_:)),
            for: .touchUpInside
        )
    }
    
    
    // MARK: - Constraints
    
    /// 모든 Constraints Configuration 함수들 호출
    private func configureConstraints() {
        configurePopupViewConstraints()
        configureTopBarConstraints()
        configureTextFieldConstraints()
        configurePeriodSelectionFieldConstraints()
        configureSubmitButtonConstraints()
    }
    
    /// 팝업 뷰 Constraints 설정
    private func configurePopupViewConstraints() {
        createNewBottlePopupView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createNewBottlePopupView.widthAnchor.constraint(
                equalToConstant: CreateNewBottlePopupView.Metric.viewWidth
            ),
            createNewBottlePopupView.heightAnchor.constraint(
                equalToConstant: CreateNewBottlePopupView.Metric.viewHeight
            ),
            createNewBottlePopupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            createNewBottlePopupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    /// 팝업 뷰 상단 바 Constraints 설정
    private func configureTopBarConstraints() {
        
        // TopBar
        NSLayoutConstraint.activate([
            createNewBottlePopupView.topBar.topAnchor.constraint(
                equalTo: self.createNewBottlePopupView.topAnchor
            ),
            createNewBottlePopupView.topBar.leadingAnchor.constraint(
                equalTo: self.createNewBottlePopupView.leadingAnchor,
                constant: PopupTopBar.Metric.cancelButtonLeadingPadding
            ),
            createNewBottlePopupView.topBar.widthAnchor.constraint(
                equalToConstant: PopupTopBar.Metric.viewWidth
            ),
            createNewBottlePopupView.topBar.heightAnchor.constraint(
                equalToConstant: PopupTopBar.Metric.viewHeight
            )
        ])
        
        // TopBar's cancel Button
        NSLayoutConstraint.activate([
            createNewBottlePopupView.topBar.cancelButton.topAnchor.constraint(
                equalTo: self.createNewBottlePopupView.topAnchor,
                constant: PopupTopBar.Metric.cancelButtonVerticalPadding
            )
        ])
        
        // TopBar's title Label
        NSLayoutConstraint.activate([
            createNewBottlePopupView.topBar.titleLabel.topAnchor.constraint(
                equalTo: self.createNewBottlePopupView.topAnchor,
                constant: PopupTopBar.Metric.titleLabelTopPadding
            ),
            createNewBottlePopupView.topBar.titleLabel.centerXAnchor.constraint(
                equalTo: self.createNewBottlePopupView.centerXAnchor
            )
        ])
    }
    
    /// 팝업 뷰의 유리병 이름 입력 필드 Constraints 설정
    private func configureTextFieldConstraints() {
        NSLayoutConstraint.activate([
            createNewBottlePopupView.textInputField.topAnchor.constraint(
                equalTo: createNewBottlePopupView.topBar.bottomAnchor,
                constant: PopupTextInputField.Metric.topPadding
            ),
            createNewBottlePopupView.textInputField.leadingAnchor.constraint(
                equalTo: createNewBottlePopupView.leadingAnchor,
                constant: CreateNewBottlePopupView.Metric.horizontalPadding
            ),
            createNewBottlePopupView.textInputField.trailingAnchor.constraint(
                equalTo: createNewBottlePopupView.trailingAnchor,
                constant: -CreateNewBottlePopupView.Metric.horizontalPadding
            ),
            createNewBottlePopupView.textInputField.widthAnchor.constraint(
                equalToConstant: PopupTextInputField.Metric.viewWidth
            ),
            createNewBottlePopupView.textInputField.heightAnchor.constraint(
                equalToConstant: PopupTextInputField.Metric.viewHeight
            )
        ])
    }
    
    /// 팝업 뷰의 기간 선택 필드 Constraints 설정
    private func configurePeriodSelectionFieldConstraints() {
        NSLayoutConstraint.activate([
            createNewBottlePopupView.periodSelectionField.topAnchor.constraint(
                equalTo: createNewBottlePopupView.textInputField.bottomAnchor,
                constant: PopupPeriodSelectionField.Metric.topPadding
            ),
            createNewBottlePopupView.periodSelectionField.leadingAnchor.constraint(
                equalTo: createNewBottlePopupView.leadingAnchor,
                constant: CreateNewBottlePopupView.Metric.horizontalPadding
            ),
            createNewBottlePopupView.periodSelectionField.trailingAnchor.constraint(
                equalTo: createNewBottlePopupView.trailingAnchor,
                constant: -CreateNewBottlePopupView.Metric.horizontalPadding
            ),
            createNewBottlePopupView.periodSelectionField.widthAnchor.constraint(
                equalToConstant: PopupPeriodSelectionField.Metric.viewWidth
            ),
            createNewBottlePopupView.periodSelectionField.heightAnchor.constraint(
                equalToConstant: PopupPeriodSelectionField.Metric.viewHeight
            )
        ])
    }
    
    /// 팝업 뷰의 제출 버튼 Constraints 설정
    private func configureSubmitButtonConstraints() {
        NSLayoutConstraint.activate([
            createNewBottlePopupView.submitButton.topAnchor.constraint(
                equalTo: createNewBottlePopupView.periodSelectionField.bottomAnchor,
                constant: CreateNewBottlePopupView.Metric.submitButtonVerticalPadding
            ),
            createNewBottlePopupView.submitButton.leadingAnchor.constraint(
                equalTo: createNewBottlePopupView.leadingAnchor,
                constant: CreateNewBottlePopupView.Metric.horizontalPadding
            ),
            createNewBottlePopupView.submitButton.trailingAnchor.constraint(
                equalTo: createNewBottlePopupView.trailingAnchor,
                constant: -CreateNewBottlePopupView.Metric.horizontalPadding
            ),
            createNewBottlePopupView.submitButton.widthAnchor.constraint(
                equalToConstant: CreateNewBottlePopupView.Metric.submitButtonWidth
            ),
            createNewBottlePopupView.submitButton.heightAnchor.constraint(
                equalToConstant: CreateNewBottlePopupView.Metric.submitButtonHeight
            )
        ])
    }
}
