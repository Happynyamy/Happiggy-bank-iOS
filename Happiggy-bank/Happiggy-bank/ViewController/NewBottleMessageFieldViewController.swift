//
//  NewBottleMessageFieldViewController.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/04/06.
//

import UIKit

/// 새 저금통 개봉 멘트 필드 뷰 컨트롤러
final class NewBottleMessageFieldViewController: UIViewController {
    
    /// 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 상단 라벨
    @IBOutlet weak var topLabel: UILabel!
    
    /// 텍스트필드
    @IBOutlet weak var textField: UITextField!
    
    /// 하단 라벨
    @IBOutlet weak var bottomLabel: UILabel!
    
    /// 유리병 데이터
    var bottleData: NewBottle!
    
    /// 유리병 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField()
        initializeLabels()
        makeNavigationBarClear()
    }
    
    
    // MARK: - IBAction
    
    /// 새 유리병 개봉 시점 피커 뷰 컨트롤러로 돌아가는 back button 액션
    /// 이전으로 돌아가도 현재 입력된 텍스트필드의 값이 저장되어야 하므로 델리게이트 함수 사용
    @IBAction func backButtonDidTap(_ sender: Any) {
        // 이전 화면으로 돌아가기
        guard let message = self.textField.text
        else { return }
        
        self.bottleData.openMessage = message
        self.delegate?.sendNewBottleData(self.bottleData ?? NewBottle())
        
        self.fadeOut()
        self.dismiss(animated: false)
    }
    
    /// 새 유리병 데이터를 코어데이터에 저장하고 홈 뷰 컨트롤러로 되돌아가는 save button 액션
    @IBAction func saveButtonDidTap(_ sender: Any) {
        saveNewBottle()
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindFromNewBottlePopupToHomeView,
            sender: sender
        )
        self.fadeOut()
    }
    
    // MARK: Functions
    
    /// 새 저금통 저장하는 메서드
    private func saveNewBottle() {
        guard let title = self.bottleData?.name,
              let endDate = self.bottleData?.endDate
        else { return }
        
        if let openMessage = self.bottleData.openMessage {
            _ = Bottle(
                title: title,
                startDate: Date(),
                endDate: endDate,
                message: openMessage
            )
        } else {
            _ = Bottle(
                title: title,
                startDate: Date(),
                endDate: endDate,
                message: StringLiteral.defaultMessage
            )
        }
        
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
        self.textField.text = bottleData.openMessage
        self.textField.layer.cornerRadius = Metric.textFieldCornerRadius
        self.textField.delegate = self
        self.textField.becomeFirstResponder()
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
        self.bottomLabel.textColor = .customTint
    }
}

extension NewBottleMessageFieldViewController: UITextFieldDelegate {
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.textField.text,
           !text.isEmpty {
            saveNewBottle()
            self.performSegue(
                withIdentifier: SegueIdentifier.unwindFromNewBottlePopupToHomeView,
                sender: nil
            )
        }
        return self.textField.resignFirstResponder()
    }
    
    /// 최대 글자수 15자 제한
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
