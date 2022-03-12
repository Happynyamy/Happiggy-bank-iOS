//
//  NewNoteTextViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새로운 쪽지의 내용을 작성하는 텍스트 뷰를 관리하는 뷰 컨트롤러
class NewNoteTextViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    /// 취소 버튼과 저장 버튼을 담고 있는 내비게이션 바
    @IBOutlet var navigationBar: UINavigationBar!
    
    /// 저장 버튼
    @IBOutlet var saveButton: UIBarButtonItem!
    
    /// 쪽지 에셋 이미지를 나타낼 뷰
    @IBOutlet var imageView: UIImageView!
    
    /// 쪽지 이미지 뷰 높이 제약 조건
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    
    /// 연도 라벨
    @IBOutlet var yearLabel: UILabel!
    
    /// 월, 일 라벨
    @IBOutlet var monthAndDayLabel: UILabel!
    
    /// 쪽지 내용을 작성할 텍스트 뷰
    @IBOutlet var textView: UITextView!
    
    /// 쪽지 색깔을 바꾸는 버튼
    @IBOutlet var colorButton: ColorButton!

    /// 쪽지 내용 글자수를 세는 라벨
    @IBOutlet var letterCountLabel: UILabel!
    
    
    // MARK: - Properties
    
    /// 새로 추가할 쪽지의 날짜, 색깔, 저금통 정보
    var newNote: NewNote!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.observe(
            selector: #selector(self.configureImageViewHeightConstraint(notification:)),
            name: UITextView.keyboardWillShowNotification
        )
        self.updateImageView()
        self.configureDateLabels()
        self.configureTextView()
        self.updateColorButton()
    }
    
    // MARK: - @IBAction
    
    /// 취소버튼(x)을 눌렀을 때 호출되는 액션 메서드 : 보틀뷰(홈뷰)로 돌아감
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.endEditingAndFadeOut()
        self.performSegue(withIdentifier: SegueIdentifier.unwindToBotteView, sender: sender)
    }
    
    /// 저장버튼(v)을 눌렀을 때 호출되는 액션 메서드
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        print("save new note to core data")
        print("notify note addition/or make core data do it...?")
        
        self.endEditingAndFadeOut()
        self.performSegue(withIdentifier: SegueIdentifier.unwindToBotteView, sender: sender)
        // TODO: activate
//        self.saveNewNote()
        self.post(name: .noteProgressDidUpdate)
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
        var index = NoteColor.allCases.firstIndex(of: sender.color) ?? .zero
        index = (index + 1) % NoteColor.allCases.count
        
        self.newNote.color = NoteColor.allCases[index]
        
        UIView.animate(withDuration: Metric.animationDuration) {
            self.updateImageView()
            self.updateColorButton()
        }
    }
    
    /// 날짜 라벨을 눌러서 띄운 날짜 피커에서 되돌아 올 때 호출되는 메서드
    @IBAction func unwindCallToNoteTexViewDidArrive(segue: UIStoryboardSegue) {
        if segue.identifier == SegueIdentifier.unwindFromNoteDatePickerToTextView {
    
            /// 날짜 선택이 바뀐 경우에만 업데이트
            guard let datePickerViewController = segue.source as? NewNoteDatePickerViewController,
                  self.newNote != datePickerViewController.newNote
            else { return }
            
            self.newNote = datePickerViewController.newNote
            self.updateDateLabels()
        }
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 투명하게 변경
    private func configureNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 쪽지 이미지 뷰 높이를 키보드를 제외한 영역을 차지하도록 업데이트
    @objc private func configureImageViewHeightConstraint(notification: NSNotification) {
        
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let imageViewHeight = Metric.imageViewHeight(
            keyboardFrame: keyboardFrame,
            navigationBarFrame: self.navigationBar.frame
        )
        self.imageViewHeightConstraint.constant = imageViewHeight
    }
    
    /// 선택한 색깔에 따라 쪽지 이미지 설정
    private func updateImageView() {
        // TODO: 에셋 받아오면 이미지 바꾸기 
        self.imageView.backgroundColor = UIColor.note(color: self.newNote.color)
    }
    
    /// 연도 라벨 볼드 처리 및 연도 라벨, 월일 라벨 날짜 업데이트
    private func configureDateLabels() {
        self.yearLabel.font = Font.yearLabelFont
        self.updateDateLabels()
    }
    
    /// 날짜 라벨들 날짜 업데이트
    private func updateDateLabels() {
        self.yearLabel.text = self.newNote.date.yearString
        self.monthAndDayLabel.text = self.newNote.date.monthDotDayString
    }
    
    /// 텍스트 뷰 관련 초기 설정
    private func configureTextView() {
        /// 바로 활성화
        self.textView.becomeFirstResponder()
        /// 인셋 설정
        self.textView.textContainerInset = .zero
    }
    
    /// 색깔 버튼 모습 업데이트
    private func updateColorButton() {
        self.colorButton.color = self.newNote.color
        self.colorButton.initialSetup(isSelected: true)
    }
    
    /// 글자수 라벨 업데이트
    private func updateLetterCountLabel(count: Int) {
        self.letterCountLabel.text = StringLiteral.letterCountText(count: count)
    }
    
    /// 100자를 초과하면 초과분을 자르고, 화면 닫을 때 매끄러운 효과를 위해 키보드를 내리고, 페이드아웃 효과를 줌
    private func endEditingAndFadeOut() {
        self.textView.endEditing(true)
        self.fadeOut()
    }
    
    /// 새로운 노트 엔티티를 생성하고 저장함
    private func saveNewNote() {
        Note.create(
            date: self.newNote.date,
            color: self.newNote.color,
            content: self.textView.text,
            bottle: self.newNote.bottle
        )
        PersistenceStore.shared.save()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentDatePickerFromNoteTextView {
            guard let dateViewController = segue.destination as? NewNoteDatePickerViewController
            else { return }
            
            dateViewController.newNote = self.newNote
            
            let viewModel = NewNoteDatePickerViewModel()
            viewModel.bottle = self.newNote.bottle
            
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
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            /// 공백이랑 빈칸으로만 입력이 이루어진 경우 저장 버튼 비활성화
            self.saveButton.isEnabled = false
            return
        }
        if !textView.text.isEmpty {
            self.saveButton.isEnabled = true
        }
    }
}
