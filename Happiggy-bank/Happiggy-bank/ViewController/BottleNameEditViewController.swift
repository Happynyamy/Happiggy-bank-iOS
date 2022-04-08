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
    
    /// 경고 라벨 보여줄지 안보여줄지 설정하는 불리언 값
    private var showWarningLabel: Bool = false
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField()
        initializeLabels()
        makeNavigationBarClear()
    }
    
    
    // MARK: IBAction
    
    /// 취소 버튼을 눌렀을 때 실행되는 액션
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.fadeOut()
        self.dismiss(animated: false)
    }
    
    /// 변경된 내용 저장
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
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
            self.warningLabel.text = StringLiteral.sameNameWarningLabel
            self.warningLabel.fadeIn()
            return
        }
        
        saveBottleData(with: text)
        self.dismiss(animated: true)
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
    
    private func saveBottleData(with text: String) {
        self.bottle.title = text
        self.bottle.hasFixedTitle = true
        PersistenceStore.shared.save()
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
}

extension BottleNameEditViewController: UITextFieldDelegate {
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = self.textField.text
        else { return self.textField.resignFirstResponder() }

        if text.isEmpty {
            HapticManager.instance.notification(type: .warning)
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.warningLabel
            self.warningLabel.fadeIn()
            return self.textField.resignFirstResponder()
        }
        
        if text == self.bottle.title {
            HapticManager.instance.notification(type: .warning)
            self.showWarningLabel = true
            self.warningLabel.text = StringLiteral.sameNameWarningLabel
            self.warningLabel.fadeIn()
            return self.textField.resignFirstResponder()
        }
        
        saveBottleData(with: text)
        self.dismiss(animated: true)
        
        return self.textField.resignFirstResponder()
    }
    
    /// 최대 글자수 10자 제한
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = self.textField.text,
              let textRange = Range(range, in: text)
        else { return false }
        
        let maxLength = self.textField.textInputMode?.primaryLanguage == StringLiteral.korean ?
        Metric.textFieldKoreanMaxLength :
        Metric.textFieldMaxLength
        
        var updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > maxLength {
            guard let overflow = Range(
                NSRange(
                    location: Metric.textFieldMaxLength,
                    length: updatedText.count - Metric.textFieldMaxLength
                ),
                in: updatedText
            )
            else { return false }
            
            updatedText.removeSubrange(overflow)
            self.textField.text = updatedText
            return false
        }
        
        return true
    }
}
