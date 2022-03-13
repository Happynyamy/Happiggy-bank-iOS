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
    @IBOutlet var navigationBar: UINavigationBar!
    
    /// 다음 화면으로 넘어가는 바 버튼
    @IBOutlet var nextButton: UIBarButtonItem!
    
    /// 상단 라벨
    lazy var topLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.topLabel
        $0.font = .systemFont(ofSize: FontSize.topLabelText)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 텍스트필드
    lazy var textField: UITextField = UITextField().then {
        $0.placeholder = StringLiteral.placeholder
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 하단 라벨
    lazy var bottomLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.bottomLabel
        $0.font = .systemFont(ofSize: FontSize.bottomLabelText)
        $0.textColor = UIColor(hex: Color.bottomLabelText)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 이름이 없을 때 표시되는 경고 라벨
    lazy var warningLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.warningLabel
        $0.font = .systemFont(ofSize: FontSize.warningLabelText)
        $0.textColor = UIColor(hex: Color.warningLabelText)
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 데이터
    var bottleData: NewBottle?
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField()
        initializeButton()
        configureViewHierarcy()
        configureConstraints()
        makeNavigationBarClear()
    }
    
    /// 새 유리병 개봉 시점 선택 뷰 컨트롤러로 이동하기 전 유리병 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewBottleDatePicker {
            guard let newBottleDatePickerViewController: NewBottleDatePickerViewController =
                    segue.destination as? NewBottleDatePickerViewController
            else { return }
            
            newBottleDatePickerViewController.delegate = self
            newBottleDatePickerViewController.bottleData = NewBottle(
                name: self.textField.text,
                periodIndex: self.bottleData?.periodIndex
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
            self.warningLabel.isHidden = false
            return
        }
        
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
            self.nextButton.tintColor = .systemGray2
            return
        }
        
        self.nextButton.tintColor = .systemBlue
        self.warningLabel.isHidden = true
    }
    
    
    // MARK: View Hierarcy
    
    /// 뷰 계층 설정하는 함수
    private func configureViewHierarcy() {
        self.view.addSubview(topLabel)
        self.view.addSubview(textField)
        self.view.addSubview(bottomLabel)
        self.view.addSubview(warningLabel)
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 투명하게 만드는 함수
    private func makeNavigationBarClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 텍스트필드 초기 세팅
    private func initializeTextField() {
        self.textField.delegate = self
        self.textField.becomeFirstResponder()
        self.textField.addTarget(
            self,
            action: #selector(self.textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    /// 다음으로 넘어가는 버튼 초기 세팅
    /// isEnabled로 하면 tapGesture 자체가 안 먹혀서 warning 줄 수 없으므로 색상 변경
    private func initializeButton() {
        self.nextButton.tintColor = .systemGray2
    }
    
    
    // MARK: Constraints
    
    /// 하위 뷰 오토레이아웃 지정하는 함수 모두 호출하는 함수
    private func configureConstraints() {
        topLabelConstraints()
        textFieldConstraints()
        bottomLabelConstraints()
        warningLabelConstraints()
    }
    
    /// 상단 라벨 오토레이아웃 설정
    private func topLabelConstraints() {
        NSLayoutConstraint.activate([
            self.topLabel.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: Metric.topLabelTopAnchor
            ),
            self.topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    /// 텍스트필드 오토레이아웃 설정
    private func textFieldConstraints() {
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(
                equalTo: self.topLabel.bottomAnchor,
                constant: Metric.textFieldTopAnchor
            ),
            self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    /// 하단 라벨 오토레이아웃 설정
    private func bottomLabelConstraints() {
        NSLayoutConstraint.activate([
            self.bottomLabel.topAnchor.constraint(
                equalTo: self.textField.bottomAnchor,
                constant: Metric.bottomLabelTopAnchor
            ),
            self.bottomLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    /// 경고 라벨 오토레이아웃 설정
    private func warningLabelConstraints() {
        NSLayoutConstraint.activate([
            self.warningLabel.topAnchor.constraint(
                equalTo: self.bottomLabel.bottomAnchor,
                constant: Metric.warningLabelTopAnchor
            ),
            self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

extension NewBottleNameFieldViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func sendNewBottleData(_ data: NewBottle) {
        self.bottleData = data
    }
}

extension NewBottleNameFieldViewController: UITextFieldDelegate {
    
    /// 리턴 키를 눌렀을 때 자동으로 다음 뷰로 넘어가며, 텍스트필드의 firstResponder 해제
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.textField.text,
           !text.isEmpty {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewBottleDatePicker,
                sender: nil
            )
        } else {
            // MARK: 유저가 시스템 설정에서 시스템 햅틱을 꺼 놓으면 작동하지 않음
            HapticManager.instance.notification(type: .warning)
            self.warningLabel.isHidden = false
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
