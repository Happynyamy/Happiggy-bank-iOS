//
//  NewBottleNameFieldViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/10.
//

import UIKit

import Then

/// 새 유리병 이름 입력하는 뷰 컨트롤러
final class NewBottleNameFieldViewController: UIViewController {
    
    // MARK: Properties
    
    /// 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 다음 화면으로 넘어가는 바 버튼
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    /// 상단 라벨
    @IBOutlet weak var topLabel: UILabel!
    
    /// 텍스트필드
    @IBOutlet weak var textField: UITextField!
    
    /// 하단 라벨
    @IBOutlet weak var bottomLabel: UILabel!
    
    /// 이름이 없을 때 표시되는 경고 라벨
    @IBOutlet weak var warningLabel: UILabel!
    
    /// 유리병 데이터
    var bottleData: NewBottle?
    
    /// 경고 라벨 보여줄지 안보여줄지 설정하는 불리언 값
    private var showWarningLabel: Bool = false
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField()
        initializeLabels()
        initializeButton()
        makeNavigationBarClear()
    }
    
    /// 새 유리병 개봉 시점 선택 뷰 컨트롤러로 이동하기 전 유리병 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewBottleDatePicker {
            guard let newBottleDatePickerViewController: NewBottleDatePickerViewController =
                    segue.destination as? NewBottleDatePickerViewController
            else { return }
            
            newBottleDatePickerViewController.delegate = self
            newBottleDatePickerViewController.viewModel.bottleData = NewBottle(
                name: self.textField.text,
                periodIndex: self.bottleData?.periodIndex,
                openMessage: self.bottleData?.openMessage
            )
        }
    }
    
    
    // MARK: IBAction
    
    /// 취소 버튼을 눌렀을 때 실행되는 액션
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.fadeOut()
        self.dismiss(animated: false)
    }
    
    /// 새 유리병 개봉 시점 선택하는 뷰 컨트롤러로 이동하는 next button 액션
    @IBAction func nextButtonDidTap(_ sender: UIBarButtonItem) {
        guard let text = self.textField.text
        else { return }
        
        if text.isEmpty {
            HapticManager.instance.notification(type: .error)
            self.showWarningLabel = true
            self.warningLabel.fadeIn()
            return
        }
        
        self.textField.endEditing(true)
        self.performSegue(
            withIdentifier: SegueIdentifier.presentNewBottleDatePicker,
            sender: sender
        )
    }
    
    /// 텍스트필드 내용이 변경됐을 때 호출되는 함수
    /// 텍스트필드의 텍스트가 있는지 없는지 판별
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text
        else { return }

        if text.isEmpty {
            self.nextButton.isEnabled = false
            self.showWarningLabel = true
            self.warningLabel.fadeIn()
            return
        }
        
        self.nextButton.isEnabled = true
        self.showWarningLabel = false
        self.warningLabel.fadeOut()
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 투명하게 만드는 함수
    private func makeNavigationBarClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 텍스트필드 초기 세팅
    private func initializeTextField() {
        self.textField.attributedPlaceholder = NSMutableAttributedString(
            string: StringLiteral.placeholder
        ).color(
            targetString: StringLiteral.placeholder,
            color: .customPlaceholderText
        )
        self.textField.layer.cornerRadius = Metric.textFieldCornerRadius
        self.textField.delegate = self
        self.textField.becomeFirstResponder()
        self.textField.addTarget(
            self,
            action: #selector(self.textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    /// 다음으로 넘어가는 버튼 초기 세팅
    private func initializeButton() {
        self.nextButton.isEnabled = false
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
    }
}

extension NewBottleNameFieldViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func sendNewBottleData(_ data: NewBottle) {
        self.bottleData = data
        self.textField.becomeFirstResponder()
    }
}

extension NewBottleNameFieldViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.count > Metric.textFieldMaxLength
        else { return }
        
        textField.text = String(text.prefix(Metric.textFieldMaxLength))
        self.textField.resignFirstResponder()
    }
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.textField.text,
           !text.isEmpty {
            textField.endEditing(true)
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewBottleDatePicker,
                sender: nil
            )
            return true
        } else {
            HapticManager.instance.notification(type: .warning)
            self.showWarningLabel = true
            self.warningLabel.fadeIn()
        }
        return false
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
        
        let maxLength = self.textField.textInputMode?.primaryLanguage == StringLiteral.korean ?
        Metric.textFieldKoreanMaxLength :
        Metric.textFieldMaxLength
        
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
