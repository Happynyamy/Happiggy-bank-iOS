//
//  NewBottleNameViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/06.
//

import UIKit

// TODO: - 1. fade in 효과 적용
// TODO: - 2. prepare에 해당하는 함수 정의

final class NewBottleNameViewController: UIViewController {
    
    // MARK: - Properties
    
    var newBottleNameView: NewBottleNameView = NewBottleNameView()
    
    var bottleData: NewBottle?
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        self.view = self.newBottleNameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureTextField()
    }
    
    
    // MARK: - objc functions
    
    /// back 버튼이 눌렸을 때 호출되는 함수
    @objc func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.fadeOut()
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    /// next 버튼이 눌렸을 때 호출되는 함수
    @objc func nextButtonDidTap(_ sender: UIBarButtonItem) {
        guard let text = self.newBottleNameView.textField.text
        else { return }
        
        if text.isEmpty {
            HapticManager.instance.notification(type: .error)
            self.newBottleNameView.warningLabel.isHidden = false
            self.newBottleNameView.warningLabel.fadeIn()
        } else {
            self.newBottleNameView.textField.endEditing(true)
            self.navigationController?.pushViewController(
                prepareNextViewController(),
                animated: false
            )
        }
    }
    
    /// 텍스트필드 내용이 변경됐을 때 호출되는 함수
    /// 텍스트필드에 텍스트가 있는지 없는지 판별
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text
        else { return }

        if text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.newBottleNameView.warningLabel.isHidden = false
            self.newBottleNameView.warningLabel.fadeIn()
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.newBottleNameView.warningLabel.isHidden = true
            self.newBottleNameView.warningLabel.fadeOut()
        }
    }
    
    
    // MARK: - configurations
    
    /// 내비게이션 바의 왼쪽, 오른쪽 버튼 아이템 설정
    private func configureNavigationItems() {
        let cancel = UIBarButtonItem(
            image: AssetImage.xmark,
            style: .plain,
            target: self,
            action: #selector(cancelButtonDidTap)
        )
        let next = UIBarButtonItem(
            image: AssetImage.next,
            style: .plain,
            target: self,
            action: #selector(nextButtonDidTap)
        )
        
        self.navigationItem.leftBarButtonItem = cancel
        self.navigationItem.rightBarButtonItem = next
        self.navigationItem.title = Text.navigationBarTitle
    }
    
    /// 텍스트필드 설정
    private func configureTextField() {
        self.newBottleNameView.textField.delegate = self
        self.newBottleNameView.textField.becomeFirstResponder()
        self.newBottleNameView.textField.addTarget(
            self,
            action: #selector(self.textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    private func prepareNextViewController() -> UIViewController {
        let newBottleDateViewController = NewBottleDateViewController()
        
        newBottleDateViewController.delegate = self
        newBottleDateViewController.viewModel.bottleData = NewBottle(
            name: self.newBottleNameView.textField.text,
            periodIndex: self.bottleData?.periodIndex,
            openMessage: self.bottleData?.openMessage
        )
        
        return newBottleDateViewController
    }
}

extension NewBottleNameViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func send(_ data: NewBottle) {
        self.bottleData = data
        self.newBottleNameView.textField.becomeFirstResponder()
    }
}

extension NewBottleNameViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.count > Metric.maxLength
        else { return }
        
        textField.text = String(text.prefix(Metric.maxLength))
        self.newBottleNameView.textField.resignFirstResponder()
    }
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.newBottleNameView.textField.text,
           !text.isEmpty {
            self.newBottleNameView.textField.endEditing(true)
            self.navigationController?.pushViewController(
                prepareNextViewController(),
                animated: false
            )
            return true
        } else {
            HapticManager.instance.notification(type: .warning)
            self.newBottleNameView.warningLabel.isHidden = false
            self.newBottleNameView.warningLabel.fadeIn()
        }
        return false
    }
    
    /// 최대 글자수 10자 제한
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        // 텍스트가 유효한지, 편집한 범위를 찾을 수 있는 지 확인
        guard let currentText = textField.text,
              Range(range, in: currentText) != nil
        else { return false }
        
        let maxLength = Metric.maxLength + 1

        let updatedTextLength = currentText.count - range.length + string.count
        let trimLength = updatedTextLength - maxLength

        guard updatedTextLength > maxLength,
              string.count >= trimLength
        else { return true }
        
        // 새로 입력된 문자열의 초과분을 삭제
        let index = string.index(string.endIndex, offsetBy: -trimLength)
        let trimmedReplacementText = string[..<index]
        
        guard let startPosition = textField.position(
            from: textField.beginningOfDocument,
            offset: range.location
        ),
              let endPosition = textField.position(
                from: textField.beginningOfDocument,
                offset: NSMaxRange(range)
              ),
              let textRange = textField.textRange(
                from: startPosition,
                to: endPosition
              )
        else { return false }
              
        textField.replace(textRange, withText: String(trimmedReplacementText))
        
        return false
    }
}

extension NewBottleNameViewController {
    enum Metric {
        /// 새 저금통 생성시 설정하는 이름의 최대 글자수(10자)
        static let maxLength: Int = 10
    }
    
    enum Text {
        /// 내비게이션 바 타이틀
        static let navigationBarTitle: String = "개인 저금통 만들기"
    }
}
