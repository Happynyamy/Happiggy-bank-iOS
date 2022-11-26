//
//  NewNoteTextViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import PhotosUI
import UIKit

/// 새로운 쪽지의 내용을 작성하는 텍스트 뷰를 관리하는 뷰 컨트롤러
final class NewNoteTextViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    /// 취소 버튼과 저장 버튼을 담고 있는 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 저장 버튼
    @IBOutlet weak var saveButton: UIBarButtonItem!

    /// 쪽지 입력 뷰
    @IBOutlet weak var newNoteInputView: NewNoteInputView!

    /// 쪽지 입력 뷰  높이 제약 조건
    @IBOutlet weak var newtNoteInputViewHeightConstraint: NSLayoutConstraint!

    /// 포토 라이브러리 버튼과 컬러 버튼들이 들어있음
    @IBOutlet weak var toolbar: UIToolbar!

    /// 사진 추가 버튼
    @IBOutlet weak var photoButton: UIBarButtonItem!

    /// 툴바에 있는 쪽지 색깔 팔레트
    @IBOutlet weak var colorPicker: ColorPickerItem!
    
    
    // MARK: - Properties
    
    /// 필요한 형식으로 데이터를 반환해주는 뷰모델로, 새로 추가할 쪽지의 날짜, 색깔, 저금통 정보를 담고 있음
    var viewModel: NewNoteTextViewModel!
    
    /// 경고 라벨 페이드인/아웃을 위한 프로퍼티
    private var showWarningLabel = false
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.clear()
        self.observe(
            selector: #selector(self.configureImageViewHeightConstraint(notification:)),
            name: UITextView.keyboardWillShowNotification
        )
        self.configureNewNoteInputView()
        self.colorPicker.delegate = self
    }

    
    // MARK: - @IBAction
    
    /// 취소버튼(x)을 눌렀을 때 호출되는 액션 메서드 : 보틀뷰(홈뷰)로 돌아감
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.endEditingAndFadeOut()
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindFromNoteTextViewToHomeView, sender: sender
        )
    }
    
    /// 저장버튼(v)을 눌렀을 때 호출되는 액션 메서드
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        guard let textView = self.newNoteInputView.textView,
              !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            self.showWarningLabel = true
            self.newNoteInputView.warningLabel.fadeIn()
            HapticManager.instance.notification(type: .error)
            self.newNoteInputView.placeholderLabel.fadeOut()
            return
        }

        textView.endEditing(true)
        self.showNoteSavingConfirmationAlert()
    }

    /// 툴바의 포토 라이브러리 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func photoButtonDidTap(_ sender: UIBarButtonItem) {
        self.presentPhotoPicker()
    }
    
    /// 날짜 라벨을 눌러서 띄운 날짜 피커에서 되돌아 올 때 호출되는 메서드
    @IBAction func unwindCallToNoteTexViewDidArrive(segue: UIStoryboardSegue) {
        self.newNoteInputView.textView.becomeFirstResponder()
        if segue.identifier == SegueIdentifier.unwindFromNoteDatePickerToTextView {

            /// 날짜 선택이 바뀐 경우에만 업데이트
            guard let datePickerViewController = segue.source as? NewNoteDatePickerViewController,
                  self.viewModel.newNote.date != datePickerViewController.viewModel.selectedDate
            else { return }

            self.viewModel.newNote.date = datePickerViewController.viewModel.selectedDate
            self.updateDateButton()
        }
    }

    /// 버튼과 텍스트 뷰 외의 영역을 터치했을 때 키보드를 내림
    @IBAction func backgroundDidTap(_ sender: Any) {
        self.newNoteInputView.textView.resignFirstResponder()
        let safeArea = self.view.safeAreaInsets
        let verticalSafeAreaInsets = safeArea.top + safeArea.bottom
        let heightThatFits = min(
            self.newNoteInputView.contentHeight,
            self.view.bounds.height - verticalSafeAreaInsets
        )
        self.newtNoteInputViewHeightConstraint.constant = heightThatFits
    }


    // MARK: - Functions

    /// 내용 스택 높이가 키보드를 제외한 영역을 차지하도록 업데이트
    @objc private func configureImageViewHeightConstraint(notification: NSNotification) {

        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let contentStackHeight = Metric.contentStackHeight(
            keyboardFrame: keyboardFrame,
            navigationBarFrame: self.navigationBar.frame
        )
        self.newtNoteInputViewHeightConstraint.constant = contentStackHeight
    }

    /// 쪽지 입력 뷰 관련 초기화
    private func configureNewNoteInputView() {
        self.updateColor()
        self.configureTextView()
        self.configureDateButton()
        self.updateLetterCountLabel(count: .zero)
        self.newNoteInputView.removePhotoButton.addAction(UIAction(handler: { [weak self] _ in
            self?.newNoteInputView.photo = nil
            self?.viewModel.newNote.imageID = nil
            self?.photoButton.isEnabled = true
        }), for: .touchUpInside)

    }

    /// 쪽지 입력 뷰의 텍스트 뷰 델리게이트 및 악세서리 뷰 설정
    private func configureTextView() {
        self.newNoteInputView.textView.inputAccessoryView = self.toolbar
        self.newNoteInputView.textView.delegate = self
        self.newNoteInputView.textView.becomeFirstResponder()
    }

    /// 쪽지 입력 뷰의 날짜 버튼에 액션 추가 및 색상 반영
    private func configureDateButton() {
        let action = UIAction { [weak self] _ in
            self?.performSegue(
                withIdentifier: SegueIdentifier.presentDatePickerFromNoteTextView,
                sender: self
            )
            self?.newNoteInputView.textView.resignFirstResponder()
        }
        self.newNoteInputView.dateButton.addAction(action, for: .touchUpInside)
        self.updateDateButton()
    }

    
    /// 유저가 선택한 색깔에 따라 배경, 테두리, 레이블 글자, 아이콘의 색상을 적절히 변경
    private func updateColor() {
        let backgroundColor = self.viewModel.backgroundColor
        let tintColor = self.viewModel.tintColor

        self.view.backgroundColor = backgroundColor
        self.newNoteInputView.backgroundNoteImageView.tintColor = tintColor
        self.newNoteInputView.dateButton.tintColor = tintColor
        self.newNoteInputView.letterCountLabel.textColor = tintColor
    }
    
    /// 쪽지 입력 뷰의 날짜 버튼 제목 업데이트
    private func updateDateButton() {
        self.newNoteInputView.dateButton.setAttributedTitle(
            self.viewModel.attributedDateButtonTitle,
            for: .normal
        )
    }
    
    /// 쪽지 입력 뷰의 글자수 라벨 업데이트
    private func updateLetterCountLabel(count: Int) {
        self.newNoteInputView.letterCountLabel.attributedText = self.viewModel
            .attributedLetterCountString(count: count)
    }
    
    /// 100자를 초과하면 초과분을 자르고, 화면 닫을 때 매끄러운 효과를 위해 키보드를 내리고, 페이드아웃 효과를 줌
    private func endEditingAndFadeOut() {
        self.newNoteInputView.textView.endEditing(true)
        self.fadeOut()
    }
    
    /// 새로운 노트 엔티티를 생성
    private func makeNewNote(withImageURL imageURL: String? = nil) -> Note {
        Note.create(
            id: self.viewModel.newNote.id,
            date: self.viewModel.newNote.date,
            color: self.viewModel.newNote.color,
            content: self.newNoteInputView.textView.text,
            imageURL: imageURL,
            bottle: self.viewModel.newNote.bottle
        )
    }
    
    /// 새로 생성한 노트 엔티티를 저장하고 성공 여부에 따라 불 리턴
    private func saveAndPostNewNote() -> Bool {
        guard let (errorTitle, errorMessage) = PersistenceStore.shared.save()
        else { return true }
        
        let alert = PersistenceStore.shared.makeErrorAlert(
            title: errorTitle,
            message: errorMessage
        ) { [weak self] _ in
            self?.dismissWithAnimation()
        }
        self.present(alert, animated: true)
        
        return false
    }
    
    /// 쪽지 저장 의사를 재확인 하는 알림을 띄움
    private func showNoteSavingConfirmationAlert() {
        let alert = self.makeConfirmationAlert()
        self.present(alert, animated: true)
    }
    
    /// 쪽지 저장 의사를 재확인하는 알림 생성
    private func makeConfirmationAlert() -> UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(
            title: StringLiteral.confirmButtonTitle
        ) { [weak self] _ in

            var imageURL = String?.none

            if let image = self?.newNoteInputView.photo,
               let errorImage = UIImage.error,
               image != errorImage {
                guard let url = self?.viewModel.saveImage(image)
                else {
                    let alert = UIAlertController.basic(
                        alertTitle: "저장에 실패했습니다.",
                        preferredStyle: .alert,
                        confirmAction: .confirmAction()
                    )
                    self?.present(alert, animated: true)
                    return
                }
                imageURL = url
            }
            
            guard let note = self?.makeNewNote(withImageURL: imageURL)
            else {
                return
            }
            
            guard self?.saveAndPostNewNote() == true
            else {
                PersistenceStore.shared.delete(note)
                if let imageURL = note.imageURL {
                    self?.viewModel.deleteImage(withImageURL: imageURL)
                }
                return
            }
            
            let noteAndDelay = (note: note, delay: CATransition.transitionDuration)
            self?.post(name: .noteDidAdd, object: noteAndDelay)
            self?.dismissWithAnimation()
        }
        
        let cancelAction = UIAlertAction.cancelAction { [weak self] _ in
            self?.newNoteInputView.textView.becomeFirstResponder()
        }
        
        return UIAlertController.basic(
            alertTitle: StringLiteral.alertTitle,
            alertMessage: StringLiteral.message,
            confirmAction: confirmAction,
            cancelAction: cancelAction
        )
    }
    
    /// 페이드아웃 효과와 함께 종료
    private func dismissWithAnimation() {
        self.fadeOut()
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindFromNoteTextViewToHomeView,
            sender: self
        )
    }


    // MARK: - Photo Selecting Functions

    private func presentPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.newNoteInputView.textView.resignFirstResponder()
        self.present(picker, animated: true)
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
            textView.text = String(textView.text.prefix(Metric.noteTextMaxLength))
            self.updateLetterCountLabel(count: textView.text.count)
        }
        
        /// 키보드 아래로 내리는 애니메이션
        textView.resignFirstResponder()
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        
        /// 텍스트가 유효한지, 편집한 범위를 찾을 수 있는 지 확인
        guard let currentText = textView.text,
              Range(range, in: currentText) != nil
        else { return false }
        
        /// 경고 라벨이 나와 있으면 숨김처리
        if self.showWarningLabel {
            self.showWarningLabel = false
            self.newNoteInputView.warningLabel.fadeOut()
        }

        var overflowCap = Metric.noteTextMaxLength
        //        if textView.textInputMode?.primaryLanguage == StringLiteral.korean {
        //            /// 한글의 경우 초성, 중성, 종성으로 이루어져 있어서 100자를 제대로 받기 위해 제한을 1글자 키움
        //            overflowCap = Metric.krOverflowCap
        //        }
        overflowCap = Metric.krOverflowCap
        
        let updatedTextLength = textView.text.count - range.length + text.count
        let trimLength = updatedTextLength - overflowCap

        guard updatedTextLength > overflowCap,
              text.count >= trimLength
        else {
            /// 내용이 빈 상태에서 백스페이스를 누르는 경우
            if textView.text.isEmpty, text.isEmpty {
                self.newNoteInputView.placeholderLabel.fadeIn()
            }
            return true
        }
        
        /// 새로 입력된 문자열의 초과분을 삭제
        let index = text.index(text.endIndex, offsetBy: -trimLength)
        let trimmedReplacementText = text[..<index]
        
        guard let startPosition = textView.position(
            from: textView.beginningOfDocument, offset: range.location
        ),
              let endPosition = textView.position(
                from: textView.beginningOfDocument, offset: NSMaxRange(range)
              ),
              let textRange = textView.textRange(from: startPosition, to: endPosition)
        else { return false }

        textView.replace(textRange, withText: String(trimmedReplacementText))
        self.updateLetterCountLabel(count: textView.text.count)
        
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let placeholderLabel = self.newNoteInputView.placeholderLabel
        if textView.text.isEmpty {
            placeholderLabel?.fadeIn()
        } else {
            placeholderLabel?.fadeOut()
        }
        self.updateLetterCountLabel(count: textView.text.count)
    }
}


// MARK: - ColorPickerDelegate

extension NewNoteTextViewController: ColorPickerDelegate {

    func selectedColorDidChange(to color: NoteColor) {
        self.viewModel.newNote.color = color
        UIView.transition(
            with: self.view,
            duration: Metric.animationDuration,
            options: .transitionCrossDissolve
        ) {
            self.updateColor()
        }
    }
}


// MARK: - PHPickerViewControllerDelegate
extension NewNoteTextViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        self.newNoteInputView.textView.becomeFirstResponder()

        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self)
        else {
            newNoteInputView.photo = results.isEmpty ? nil : .error
            viewModel.newNote.imageID = nil
            self.photoButton.isEnabled = results.isEmpty
            return
        }

        saveButton.isEnabled = false
        // TODO: Use Progress View
        _ = result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            DispatchQueue.main.async {
                self?.saveButton.isEnabled = true
                self?.photoButton.isEnabled = false

                guard let image = object as? UIImage
                else {
                    self?.viewModel.newNote.imageID = nil
                    self?.newNoteInputView.photo = .error
                    return
                }

                self?.newNoteInputView.photo = image
                self?.viewModel.newNote.imageID = result.assetIdentifier ?? UUID().uuidString
            }
        }
    }
}
