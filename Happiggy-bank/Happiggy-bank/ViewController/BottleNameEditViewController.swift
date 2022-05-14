//
//  BottleNameEditViewController.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/08.
//

import UIKit

import Then

/// 새 유리병 이름 입력하는 뷰 컨트롤러
final class BottleNameEditViewController: UIViewController {
    
    // MARK: Properties
    
    /// 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 다음 화면으로 넘어가는 바 버튼
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /// 상단 라벨
    @IBOutlet weak var topLabel: UILabel!
    
    /// 텍스트필드
    @IBOutlet weak var textField: UITextField!
    
    /// 하단 라벨
    @IBOutlet weak var bottomLabel: UILabel!
    
    /// 이름이 없을 때 표시되는 경고 라벨
    @IBOutlet weak var warningLabel: UILabel!
    
    /// 유리병 데이터
    var bottle: Bottle!
    
    /// 부모 뷰 컨트롤러
    weak var delegate: Presenter!
    
    /// 경고 라벨 보여줄지 안보여줄지 설정하는 불리언 값
    private var showWarningLabel: Bool = false
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField()
        initializeLabels()
        self.navigationBar.clear()
    }
    
    
    // MARK: IBAction
    
    /// 취소 버튼을 눌렀을 때 실행되는 액션
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.dismiss(withResult: .cancel)
    }
    
    /// 변경된 내용 저장
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        self.prefixTextByMaxLengthIfNeeded(inTextField: self.textField)
        
        guard let text = self.textField.text
        else { return }

        if text.isEmpty {
            HapticManager.instance.notification(type: .error)
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.warningLabel
            self.warningLabel.fadeIn()
            
            return
        }
        
        if text == self.bottle.title {
            HapticManager.instance.notification(type: .error)
            self.showWarningLabel = true
            self.warningLabel.isHidden = false
            self.warningLabel.text = StringLiteral.sameNameWarningLabel
            self.warningLabel.fadeIn()
            
            return
        }
        
        guard saveBottleData(with: text) == true
        else { return }
        
        self.dismiss(withResult: .success)
    }
    
    /// 텍스트필드 내용이 변경됐을 때 호출되는 함수
    /// 텍스트필드의 텍스트가 있는지 없는지 판별
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text
        else { return }

        if text.isEmpty {
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.warningLabel
            self.warningLabel.isHidden = false
            self.warningLabel.fadeIn()
            return
        }
        
        if text == bottle.title {
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.sameNameWarningLabel
            self.warningLabel.isHidden = false
            self.warningLabel.fadeIn()
            return
        }
        
        self.showWarningLabel = false
        self.warningLabel.fadeOut()
    }
    
    
    // MARK: Functions
    
    private func saveBottleData(with text: String) -> Bool {
        self.bottle.title = text
        
        guard let (errorTitle, errorMessage) = PersistenceStore.shared.save()
        else { return true }
        
        let alert = PersistenceStore.shared.makeErrorAlert(
            title: errorTitle,
            message: errorMessage
        ) { _ in
            self.dismiss(withResult: .failure)
        }
        
        self.present(alert, animated: true)
        return false
    }
    
    
    // MARK: View Configuration
    
    /// 텍스트필드 초기 세팅
    private func initializeTextField() {
        self.textField.attributedPlaceholder = NSMutableAttributedString(
            string: StringLiteral.placeholder
        ).color(
            targetString: StringLiteral.placeholder,
            color: .customPlaceholderText
        )
        self.textField.text = self.bottle.title
        self.textField.layer.cornerRadius = Metric.textFieldCornerRadius
        self.textField.delegate = self
        self.textField.becomeFirstResponder()
        self.textField.addTarget(
            self,
            action: #selector(self.textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    /// 라벨 초기 세팅
    private func initializeLabels() {
        // top label
        self.topLabel.text = StringLiteral.topLabel
        self.topLabel.font = .systemFont(ofSize: FontSize.topLabelText)
        self.topLabel.textColor = .customLabel
        
        // bottom label
        self.bottomLabel.text = StringLiteral.bottomLabel
        self.bottomLabel.font = .systemFont(ofSize: FontSize.bottomLabelText)
        self.bottomLabel.textColor = .customSecondaryLabel
        
        // warning label
        self.warningLabel.text = StringLiteral.warningLabel
        self.warningLabel.font = .systemFont(ofSize: FontSize.warningLabelText)
        self.warningLabel.textColor = .customWarningLabel
        self.warningLabel.isHidden = true
    }
    
    /// 종료 시 호출하는 메서드
    private func dismiss(withResult result: CustomResult) {
        self.resignFirstResponder()
        self.dismiss(animated: true)
        self.delegate.presentedViewControllerDidDismiss(withResult: result)
    }
    
    /// 최대 길이 초과 시 텍스트필드의 입력 값을 자르는 메서드
    private func prefixTextByMaxLengthIfNeeded(inTextField textField: UITextField) {
        guard let text = textField.text,
              text.count > Metric.textFieldMaxLength
        else { return }
        
        textField.text = String(text.prefix(Metric.textFieldMaxLength))
    }
}


// MARK: - UITextFieldDelegate
extension BottleNameEditViewController: UITextFieldDelegate {
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.prefixTextByMaxLengthIfNeeded(inTextField: textField)
        
        guard let text = textField.text
        else { return false }

        if text.isEmpty {
            HapticManager.instance.notification(type: .warning)
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.warningLabel
            self.warningLabel.fadeIn()
            
            return false
        }
        
        if text == self.bottle.title {
            HapticManager.instance.notification(type: .warning)
            self.warningLabel.isHidden = false
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.sameNameWarningLabel
            self.warningLabel.fadeIn()
            
            return true
        }
        
        guard saveBottleData(with: text) == true
        else { return false }
        
        self.dismiss(withResult: .success)
        return true
    }
    
    /// 최대 글자수 10자 제한
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        /// 텍스트가 유효한지, 편집한 범위를 찾을 수 있는 지 확인
        guard let currentText = textField.text,
              Range(range, in: currentText) != nil
        else { return false }
        
//        let maxLength = self.textField.textInputMode?.primaryLanguage == StringLiteral.korean ?
//        Metric.textFieldKoreanMaxLength :
//        Metric.textFieldMaxLength
        let maxLength = Metric.textFieldKoreanMaxLength
        
        let updatedTextLength = currentText.count - range.length + string.count
        let trimLength = updatedTextLength - maxLength

        guard updatedTextLength > maxLength,
              string.count >= trimLength
        else { return true }
        
        /// 새로 입력된 문자열의 초과분을 삭제
        let index = string.index(string.endIndex, offsetBy: -trimLength)
        let trimmedReplacementText = string[..<index]
        
        guard let startPosition = textField.position(
            from: textField.beginningOfDocument, offset: range.location
        ),
              let endPosition = textField.position(
                from: textField.beginningOfDocument, offset: NSMaxRange(range)
              ),
              let textRange = textField.textRange(from: startPosition, to: endPosition)
        else { return false }
              
        textField.replace(textRange, withText: String(trimmedReplacementText))
        
        return false
    }
}
