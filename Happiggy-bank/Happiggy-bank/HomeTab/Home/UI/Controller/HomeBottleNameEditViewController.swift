//
//  HomeBottleNameEditViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/07/06.
//

import UIKit

final class HomeBottleNameEditViewController: UIViewController {
    
    // MARK: - Properties
    
    var nameEditView = BottleNameEditView()
    
    var bottleData: Bottle?
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = self.nameEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureTextField()
    }
    
    
    // MARK: - objc functions
    
    /// back 버튼이 눌렸을 때 호출되는 함수
    @objc func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerWithFade()
    }
    
    /// save 버튼이 눌렸을 때 호출되는 함수
    @objc func saveButtonDidTap(_ sender: UIBarButtonItem) {
        guard let text = self.nameEditView.textField.text
        else { return }
        
        if text.isEmpty {
            HapticManager.instance.notification(type: .error)
            self.nameEditView.warningLabel.isHidden = false
            self.nameEditView.warningLabel.fadeIn()
        } else {
            self.nameEditView.textField.endEditing(true)
            self.present(self.confirmationAlert(), animated: true)
        }
    }
    
    /// 텍스트필드 내용이 변경됐을 때 호출되는 함수
    /// 텍스트필드에 텍스트가 있는지 없는지 판별
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text
        else { return }

        if text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.nameEditView.warningLabel.isHidden = false
            self.nameEditView.warningLabel.fadeIn()
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.nameEditView.warningLabel.isHidden = true
            self.nameEditView.warningLabel.fadeOut()
        }
    }
    
  
    // MARK: - Functions
    
    /// 변경한 저금통 이름이 원본과 같은지 체크하는 메서드
    private func checkIfNameIsChanged() -> Bool {
        guard let currentBottle = bottleData,
              let editedName = nameEditView.textField.text
        else { return false }
        
        return currentBottle.title != editedName
    }
    
    /// 새 저금통 저장하는 메서드
    private func saveBottle() -> Bool {
        guard let currentBottle = bottleData,
              let editedName = nameEditView.textField.text
        else { return false }
        
        currentBottle.title = editedName
        let result = PersistenceStore.shared.save()
        
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// 생성 확인 알림을 나타냄
    private func confirmationAlert() -> UIAlertController {
        
        let confirmAction = UIAlertAction.confirmAction(
            title: Text.confirmationAlertConfirmButtonTitle
        ) { _ in
            let isNewNameValid = self.checkIfNameIsChanged()
            
            guard isNewNameValid == true
            else {
                self.present(
                    self.invalidDataFailureAlert(),
                    animated: false
                )
                return
            }
            guard self.saveBottle() == true
            else {
                self.present(
                    self.fetchFailureAlert(),
                    animated: false
                )
                return
            }
          
            self.navigationController?.popToRootViewControllerWithFade()
        }
        
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.nameEditView.textField.becomeFirstResponder()
        }
        
        return UIAlertController.basic(
            alertTitle: Text.confirmationAlertTitle,
            alertMessage: Text.confirmationAlertMessage,
            confirmAction: confirmAction,
            cancelAction: cancelAction
        )
    }
    
    /// 데이터가 조건에 맞지 않을 때 나타나는 알림
    private func invalidDataFailureAlert() -> UIAlertController {
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.nameEditView.textField.becomeFirstResponder()
        }
        
        return UIAlertController.cancel(
            alertTitle: Text.cancelAlertTitle,
            alertMessage: Text.cancelAlertMessage,
            cancelAction: cancelAction
        )
    }
    
    /// 에러 발생시 나타나는 알림
    private func fetchFailureAlert() -> UIAlertController {
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.nameEditView.textField.becomeFirstResponder()
        }
        
        return UIAlertController.cancel(
            alertTitle: Text.errorAlertTitle,
            alertMessage: Text.errorAlertMessage,
            cancelAction: cancelAction
        )
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
            image: AssetImage.checkmark,
            style: .plain,
            target: self,
            action: #selector(saveButtonDidTap)
        )
        
        self.navigationItem.leftBarButtonItem = cancel
        self.navigationItem.rightBarButtonItem = next
        self.navigationItem.title = Text.navigationBarTitle
    }
    
    /// 텍스트필드 설정
    private func configureTextField() {
        self.nameEditView.textField.text = bottleData?.title
        self.nameEditView.textField.delegate = self
        self.nameEditView.textField.becomeFirstResponder()
        self.nameEditView.textField.addTarget(
            self,
            action: #selector(self.textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
}

extension HomeBottleNameEditViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.count > Metric.maxLength
        else { return }
        
        textField.text = String(text.prefix(Metric.maxLength))
        self.nameEditView.textField.resignFirstResponder()
    }
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.nameEditView.textField.text,
           !text.isEmpty {
            textField.endEditing(true)
            self.present(self.confirmationAlert(), animated: true)
            return true
        } else {
            HapticManager.instance.notification(type: .warning)
            self.nameEditView.warningLabel.isHidden = false
            self.nameEditView.warningLabel.fadeIn()
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

// MARK: - Data Provider
extension HomeBottleNameEditViewController: DataProvider {
  func sendOriginalData(_ data: Bottle) {
    self.bottleData = data
  }
}

extension HomeBottleNameEditViewController {
    enum Metric {
        /// 저금통 이름의 최대 글자수(10자)
        static let maxLength: Int = 10
    }
    
    enum Text {
        /// 내비게이션 바 타이틀
        static let navigationBarTitle: String = "저금통 이름 변경"
      
        /// 생성 확인 알림 제목
        static let confirmationAlertTitle = "저금통 이름을 변경하시겠어요?"
        
        /// 생성 확인 알림 내용
        static let confirmationAlertMessage = "저금통 이름은 언제든 다시 변경할 수 있어요!"
        
        /// 생성 확인 알림 확인 버튼 제목: 추가
        static let confirmationAlertConfirmButtonTitle = "변경"
        
        /// 생성 정보 부적합 알림 제목
        static let cancelAlertTitle = "정보가 정상적으로 입력되지 않았습니다."
        
        /// 생성 정보 부적합 알림 내용
        static let cancelAlertMessage = "저금통 이름을 다시 확인해주세요."
        
        /// 정보 저장 실패 알림 제목
        static let errorAlertTitle: String = "변경사항 저장에 실패했습니다"
        
        /// 정보 저장 실패 알림 내용
        static let errorAlertMessage: String = """
        디바이스의 저장 공간이 충분한지 확인해주세요.
        같은 문제가 계속 발생하는 경우 \(teamMail) 으로 문의 부탁드립니다.
        """
    }
}
