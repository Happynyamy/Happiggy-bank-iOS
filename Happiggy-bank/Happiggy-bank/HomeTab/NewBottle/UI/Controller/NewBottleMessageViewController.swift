//
//  NewBottleMessageViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/08.
//

import Combine
import CoreData
import UIKit

final class NewBottleMessageViewController: UIViewController {

    // MARK: - Properties
    
    /// 컨트롤러의 메인 뷰
    var newBottleMessageView: NewBottleMessageView = NewBottleMessageView()
    
    /// 새로 생성중인 저금통 데이터
    var bottleData: NewBottle!
    
    /// 저금통 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    /// 뷰 모델
    private var viewModel: NewBottleViewModel = NewBottleViewModel()
    
    private var cancellableBag = Set<AnyCancellable>()
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
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
        
        self.navigationController?.popViewControllerWithFade()
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
    
    /// 새 저금통 데이터가 유효한지 체크하는 메서드
    private func checkNewBottleData() -> Bool {
        self.bottleData.openMessage = self.newBottleMessageView.textField.text
        let result = self.viewModel.createNewBottle(with: self.bottleData)
        
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// 새 저금통 저장하는 메서드
    private func saveBottle() -> Bool {
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
            let isNewBottleDataValid = self.checkNewBottleData()
            self.navigationController?.popToRootViewControllerWithFade()
            
            guard isNewBottleDataValid == true
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
    
    /// 데이터가 조건에 맞지 않을 때 나타나는 알림
    private func invalidDataFailureAlert() -> UIAlertController {
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.newBottleMessageView.textField.becomeFirstResponder()
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
            self.newBottleMessageView.textField.becomeFirstResponder()
        }
        
        return UIAlertController.cancel(
            alertTitle: Text.errorAlertTitle,
            alertMessage: Text.errorAlertMessage,
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
        
        /// 생성 정보 부적합 알림 제목
        static let cancelAlertTitle = "정보가 정상적으로 입력되지 않았습니다."
        
        /// 생성 정보 부적합 알림 내용
        static let cancelAlertMessage = "저금통 이름, 날짜, 개봉 메시지를 다시 확인해주세요."
        
        /// 정보 저장 실패 알림 제목
        static let errorAlertTitle: String = "변경사항 저장에 실패했습니다"
        
        /// 정보 저장 실패 알림 내용
        static let errorAlertMessage: String = """
        디바이스의 저장 공간이 충분한지 확인해주세요.
        같은 문제가 계속 발생하는 경우 \(teamMail) 으로 문의 부탁드립니다.
        """
    }
}
