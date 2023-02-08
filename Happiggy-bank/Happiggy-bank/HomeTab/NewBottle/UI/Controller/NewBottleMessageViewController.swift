//
//  NewBottleMessageViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/08.
//

import UIKit

class NewBottleMessageViewController: UIViewController {

    // MARK: - Properties
    
    /// 컨트롤러의 메인 뷰
    var newBottleMessageView: NewBottleMessageView = NewBottleMessageView()
    
    /// 새로 생성중인 저금통 데이터
    var bottleData: NewBottle!
    
    /// 저금통 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        self.view = self.newBottleMessageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureTextField()
    }
    
    
    // MARK: - objc functions
    
    /// back 버튼이 눌렸을 때 호출되는 함수
    @objc func backButtonDidTap(_ sender: UIBarButtonItem) {
        self.newBottleMessageView.textField.endEditing(true)
        // 이전 화면으로 돌아가기
        guard let message = self.newBottleMessageView.textField.text
        else { return }
        
        self.bottleData.openMessage = message
        self.delegate?.send(self.bottleData ?? NewBottle())
        
        self.fadeOut()
        self.navigationController?.popViewController(animated: false)
    }
    
    /// 새 유리병 데이터를 코어데이터에 저장하고 홈 뷰 컨트롤러로 되돌아가는 save button 액션
    @objc func saveButtonDidTap(_ sender: UIBarButtonItem) {
        self.newBottleMessageView.textField.endEditing(true)
        self.present(self.confirmationAlert(), animated: true)
    }

    
    // MARK: - configurations
    
    /// 내비게이션 바의 왼쪽, 오른쪽 버튼 아이템 설정
    private func configureNavigationItems() {
        let back = UIBarButtonItem(
            image: AssetImage.back,
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        let save = UIBarButtonItem(
            image: AssetImage.checkmark,
            style: .plain,
            target: self,
            action: #selector(saveButtonDidTap)
        )
        
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.rightBarButtonItem = save
        self.navigationItem.title = Text.navigationBarTitle
    }
    
    /// 텍스트필드 설정
    private func configureTextField() {
        self.newBottleMessageView.textField.delegate = self
        self.newBottleMessageView.textField.becomeFirstResponder()
    }
    
    
    // MARK: - Functions
    
    // TODO: - fetchedResultsController로 변경
    /// 새 저금통 저장하는 메서드
    private func saveNewBottle() -> Bool {
        self.bottleData.openMessage = self.newBottleMessageView.textField.text
        
        guard let title = self.bottleData?.name,
              let endDate = self.bottleData?.endDate
        else { return false }
        
        var bottle: Bottle
        
        if let openMessage = self.bottleData.openMessage, !openMessage.isEmpty {
            bottle = Bottle(
                title: title,
                startDate: Date(),
                endDate: endDate,
                message: openMessage
            )
        } else {
            bottle = Bottle(
                title: title,
                startDate: Date(),
                endDate: endDate,
                message: Text.defaultMessage
            )
        }
        
        guard let (errorTitle, errorMessage) = PersistenceStore.shared.saveOld()
        else { return true }
        
        let alert = PersistenceStore.shared.makeErrorAlert(
            title: errorTitle,
            message: errorMessage
        ) { _ in
            self.fadeOut()
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        PersistenceStore.shared.delete(bottle)
        self.present(alert, animated: true)
        return false
    }
    
    /// 생성 확인 알림을 나타냄
    private func confirmationAlert() -> UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(
            title: Text.confirmationAlertConfirmButtonTitle
        ) { _ in
            guard self.saveNewBottle() == true
            else { return }
            
            self.fadeOut()
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.newBottleMessageView.textField.becomeFirstResponder()
        }
        
        return UIAlertController.basic(
            alertTitle: Text.confirmationAlertTitle,
            alertMessage: Text.confirmationAlertMessage,
            confirmAction: confirmAction,
            cancelAction: cancelAction
        )
    }
}

extension NewBottleMessageViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func send(_ data: NewBottle) {
        self.bottleData = data
        self.newBottleMessageView.textField.becomeFirstResponder()
    }
}

extension NewBottleMessageViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.count > Metric.maxLength
        else { return }
        
        textField.text = String(text.prefix(Metric.maxLength))
        self.newBottleMessageView.textField.resignFirstResponder()
    }
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.present(self.confirmationAlert(), animated: true)
        
        return true
    }
    
    /// 최대 글자수 15자 제한
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

extension NewBottleMessageViewController {
    
    enum Metric {
        
        /// 새 저금통 생성시 설정하는 한마디 최대 글자수(15자)
        static let maxLength: Int = 15
    }
    
    enum Text {
        
        /// 내비게이션 바 타이틀
        static let navigationBarTitle: String = "개인 저금통 만들기"
        
        /// 한마디 입력하지 않았을 시 자동으로 설정되는 디폴트 메시지
        static let defaultMessage: String = "반가워 내 행복들아!"
        
        /// 생성 확인 알림 제목
        static let confirmationAlertTitle = "저금통을 추가하시겠어요?"
        
        /// 생성 확인 알림 내용
        static let confirmationAlertMessage = "추가 후에는 개봉날짜 변경 및 저금통 삭제가 불가합니다."
        
        /// 생성 확인 알림 확인 버튼 제목: 추가
        static let confirmationAlertConfirmButtonTitle = "추가"
    }
}
