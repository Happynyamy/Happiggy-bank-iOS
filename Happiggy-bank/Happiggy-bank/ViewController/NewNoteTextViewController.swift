//
//  NewNoteTextViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새로운 쪽지의 내용을 작성하는 텍스트 뷰를 관리하는 뷰 컨트롤러
final class NewNoteTextViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    /// 쪽지 색깔 선택 버튼들
    @IBOutlet var colorButtons: [ColorButton]!
    
    /// 컬러 버튼들을 담고 있는 컨테이너 뷰
    @IBOutlet weak var colorButtonContainerView: UIView!
    
    /// 취소 버튼과 저장 버튼을 담고 있는 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 저장 버튼
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /// 쪽지 에셋 이미지를 나타낼 뷰
    @IBOutlet weak var imageView: UIImageView!
    
    /// 내용 스택 높이 제약 조건
    @IBOutlet weak var contentStackHeightConstraint: NSLayoutConstraint!
    
    /// 연도 라벨
    @IBOutlet weak var yearLabel: UILabel!
    
    /// 월, 일 라벨
    @IBOutlet weak var monthAndDayLabel: UILabel!
    
    /// 쪽지 내용을 작성할 텍스트 뷰
    @IBOutlet weak var textView: UITextView!

    /// 쪽지 내용 글자수를 세는 라벨
    @IBOutlet weak var letterCountLabel: UILabel!
    
    /// 입력한 내용 없이 저장 버튼을 누를 때 표시하는 경고 라벨
    @IBOutlet weak var warningLabel: UILabel!
    
    
    // MARK: - Properties
    
    /// 필요한 형식으로 데이터를 반환해주는 뷰모델로, 새로 추가할 쪽지의 날짜, 색깔, 저금통 정보를 담고 있음
    var viewModel: NewNoteTextViewModel!
    
    /// 경고 라벨 페이드인/아웃을 위한 프로퍼티
    private var showWarningLabel = false
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.observe(
            selector: #selector(self.configureImageViewHeightConstraint(notification:)),
            name: UITextView.keyboardWillShowNotification
        )
        self.updateImageView()
        self.updateDateLabels()
        self.configureTextView()
        self.updateColorButtons()
        self.updateLetterCountLabel(count: .zero)
    }
    
    
    // MARK: - @IBAction
    
    /// 취소버튼(x)을 눌렀을 때 호출되는 액션 메서드 : 보틀뷰(홈뷰)로 돌아감
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.endEditingAndFadeOut()
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindToBottleViewFromNoteTextView, sender: sender
        )
    }
    
    /// 저장버튼(v)을 눌렀을 때 호출되는 액션 메서드
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        
        guard !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            self.showWarningLabel = true
            self.warningLabel.fadeIn()
            HapticManager.instance.notification(type: .error)
            return
        }

        self.textView.endEditing(true)
        self.showNoteSavingConfirmationAlert()
    }
    
    /// 날짜 라벨을 눌렀을 때 호출되는 액션 메서드 : 날짜 피커 뷰로 넘어감
    @IBAction func dateLabelsDidTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(
            withIdentifier: SegueIdentifier.presentDatePickerFromNoteTextView,
            sender: self
        )
    }
    
    /// 색깔 버튼을 눌렀을 때 호출 되는 액션 메서드 : 선택한 쪽지 색깔을 바꿈
    @IBAction func colorButtonDidTap(_ sender: ColorButton) {
        guard sender.color != self.viewModel.newNote.color
        else { return }
        
        self.colorButtons.forEach { $0.updateState(isSelected: $0.color == sender.color)}
        self.viewModel.newNote.color = sender.color
        
        UIView.transition(with: self.view, duration: Metric.animationDuration, options: .transitionCrossDissolve) {
            self.updateImageView()
            self.updateColorButtons()
            self.updateLabelColors()
        }
    }
    
    /// 날짜 라벨을 눌러서 띄운 날짜 피커에서 되돌아 올 때 호출되는 메서드
    @IBAction func unwindCallToNoteTexViewDidArrive(segue: UIStoryboardSegue) {
        if segue.identifier == SegueIdentifier.unwindFromNoteDatePickerToTextView {
    
            /// 날짜 선택이 바뀐 경우에만 업데이트
            guard let datePickerViewController = segue.source as? NewNoteDatePickerViewController,
                  self.viewModel.newNote.date != datePickerViewController.viewModel.selectedDate
            else { return }
            
            self.viewModel.newNote.date = datePickerViewController.viewModel.selectedDate
            self.updateDateLabels()
        }
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 투명하게 변경
    private func configureNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 내용 스택 높이가 키보드를 제외한 영역을 차지하도록 업데이트
    @objc private func configureImageViewHeightConstraint(notification: NSNotification) {
        
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let contentStackHeight = Metric.contentStackHeight(
            keyboardFrame: keyboardFrame,
            navigationBarFrame: self.navigationBar.frame
        )
        self.contentStackHeightConstraint.constant = contentStackHeight
    }
    
    /// 색깔 버튼들 상태 설정
    private func updateColorButtons() {
        for (button, color) in zip(self.colorButtons, NoteColor.allCases) {
            button.color = color
            button.initialSetup(isSelected: button.color == self.viewModel.newNote.color)
        }
    }
    
    /// 선택한 색깔에 따라 쪽지 이미지 설정
    private func updateImageView() {
        self.view.backgroundColor = self.viewModel.backgroundColor
        self.imageView.image = self.viewModel.noteImage
    }
    
    /// 연도 라벨 볼드 처리 및 연도 라벨, 월일 라벨 날짜 업데이트
    private func updateDateLabels() {
        self.yearLabel.attributedText = self.viewModel.attributedYearString
        self.monthAndDayLabel.attributedText = self.viewModel.attributedMonthDayString
    }
    
    /// 텍스트 뷰 관련 초기 설정
    private func configureTextView() {
        /// 바로 활성화
        self.textView.becomeFirstResponder()
        /// 인셋 설정
        self.textView.textContainerInset = .zero
    }
    
    /// 글자수 라벨 업데이트
    private func updateLetterCountLabel(count: Int) {
        self.letterCountLabel.attributedText = self.viewModel
                                                    .attributedLetterCountString(count: count)
    }
    
    /// 100자를 초과하면 초과분을 자르고, 화면 닫을 때 매끄러운 효과를 위해 키보드를 내리고, 페이드아웃 효과를 줌
    private func endEditingAndFadeOut() {
        self.textView.endEditing(true)
        self.fadeOut()
    }
    
    /// 날짜 라벨들, 글자수 라벨의 색상 업데이트
    private func updateLabelColors() {
        self.yearLabel.textColor = self.viewModel.labelColor
        self.monthAndDayLabel.textColor = self.viewModel.labelColor
        self.letterCountLabel.textColor = self.viewModel.labelColor
    }
    
    /// 새로운 노트 엔티티를 생성하고 저장하며, 저장 시에 쪽지가 추가되었다는 노티피케이션을 날림
    private func saveNewNote() {
        let note = Note.create(
            date: self.viewModel.newNote.date,
            color: self.viewModel.newNote.color,
            content: self.textView.text,
            bottle: self.viewModel.newNote.bottle
        )
        let noteAndDelay = (note: note, delay: CATransition.transitionDuration)
        self.post(name: .noteDidAdd, object: noteAndDelay)
        // TODO: activate core data
        PersistenceStore.shared.save()
    }
    
    /// 쪽지 저장 의사를 재확인 하는 알림을 띄움
    private func showNoteSavingConfirmationAlert() {
        let alert = self.makeConfirmationAlert()
        self.present(alert, animated: true)
    }
    
    /// 쪽지 저장 의사를 재확인하는 알림 생성
    private func makeConfirmationAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: StringLiteral.alertTitle,
            message: StringLiteral.message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: StringLiteral.confirmButtonTitle,
            style: .default) { _ in
                self.fadeOut()
                self.performSegue(
                    withIdentifier: SegueIdentifier.unwindToBottleViewFromNoteTextViewBySave,
                    sender: self
                )
                self.saveNewNote()
            }
        
        let cancelAction = UIAlertAction(
            title: StringLiteral.cancelButtonTitle,
            style: .cancel) { _ in
                self.textView.becomeFirstResponder()
            }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        return alert
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentDatePickerFromNoteTextView {
            guard let dateViewController = segue.destination as? NewNoteDatePickerViewController
            else { return }
            
            let viewModel = NewNoteDatePickerViewModel(
                initialDate: self.viewModel.newNote.date,
                bottle: self.viewModel.newNote.bottle
            )
            
            dateViewController.viewModel = viewModel
            dateViewController.isFromNoteTextView = true
        }
    }
}


// MARK: - UITextViewDelegate

extension NewNoteTextViewController: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        
        /// 100자 초과 시 초과분 삭제
        if textView.text.count > Metric.noteTextMaxLength {
            textView.deleteBackward()
            self.updateLetterCountLabel(count: textView.text.count)
        }
        
        /// 키보드 아래로 내리는 애니메이션
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        /// 텍스트가 유효한지, 편집한 범위를 찾을 수 있는 지 확인
        guard let currentText = textView.text,
              let updateRange = Range(range, in: currentText)
        else { return false }
        
        /// 경고 라벨이 나와 있으면 숨김처리
        if self.showWarningLabel {
            self.showWarningLabel = false
            self.warningLabel.fadeOut()
        }
        
        /// 편집한 내용을 반영해서 텍스트 뷰에 들어갈 텍스트 재구성
        var newText = currentText.replacingCharacters(in: updateRange, with: text)
        
        var overflowCap = Metric.noteTextMaxLength
        if textView.textInputMode?.primaryLanguage == StringLiteral.korean {
            /// 한글의 경우 초성, 중성, 종성으로 이루어져 있어서 100자를 제대로 받기 위해 제한을 1글자 키움
            overflowCap = Metric.krOverflowCap
        }
        
        if newText.count > overflowCap {
            /// 100자를 초과하는 경우
            guard let overflowRange = Range(
                NSRange(
                    location: Metric.noteTextMaxLength,
                    length: newText.count - Metric.noteTextMaxLength
                ),
                in: newText
            )
            else { return false }
            
            /// 유저가 텍스트를 복사해와서 붙였는데 100자를 초과하는 경우 100자까지만 붙이기 위한 작업
            newText.removeSubrange(overflowRange)
            self.textView.text = newText
            self.updateLetterCountLabel(count: self.textView.text.count)
            
            return false
        }
        
        /// 100자를 초과하지 않는 경우 편집 사항 반영
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateLetterCountLabel(count: textView.text.count)
        
        /// 자간, 행간 설정
        textView.configureParagraphStyle(
            lineSpacing: Metric.lineSpacing,
            characterSpacing: Metric.characterSpacing
        )
        
        /// 버튼 색깔 변경
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.saveButton.tintColor = .customGray
            return
        }
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.saveButton.tintColor = .systemBlue
        }
    }
}
