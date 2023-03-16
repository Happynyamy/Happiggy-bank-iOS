//
//  NewNoteInputViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import PhotosUI
import UIKit

import SnapKit
import Then

/// 새로운 쪽지를 추가할 때 사용하는 뷰 컨트롤러
/// 쪽지 추가 시 이를 알리기 위해 델리게이트 설정 필요
final class NewNoteInputViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: NewNoteSavingDelegate?
    private let viewModel: NewNoteInputViewModel
    private let noteInputView = NewNoteInputView()
    /// 에러 로그 방지를 위해 임의의 초기값 설정
    private let toolbar = NewNoteInputToolbar(frame: .init(origin: .zero, size: .init(width: 1000, height: 50)))
    private var showWarningLabel = false
    private var noteInputViewBotttomConstraint: Constraint?
    private var toolbarBottomConstraint: Constraint?


    // MARK: - Init(s)

    init(viewModel: NewNoteInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
        self.configureViews()
        self.configureToolbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.noteInputView.textView.becomeFirstResponder()
        self.updateCalendarButtonTitleText()
    }


    // MARK: - NavigationBar Configuration Functions

    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: AssetImage.xmark,
            primaryAction: .init { [weak self] _ in
                self?.noteInputView.textView.endEditing(true)
                self?.navigationController?.popToRootViewControllerWithFade()
            }
        )
        let saveButton = UIBarButtonItem(
            image: AssetImage.checkmark,
            primaryAction: .init { [weak self] _ in self?.saveButtonDidTap() }
        )
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        self.navigationItem.setRightBarButton(saveButton, animated: true)

        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .none
    }

    private func saveButtonDidTap() {
        let textView = self.noteInputView.textView
        guard !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            HapticManager.instance.notification(type: .error)
            self.showWarningLabel = true
            self.noteInputView.warningLabel.fadeIn()
            self.noteInputView.placeholderLabel.fadeOut()
            return
        }

        textView.endEditing(true)
        self.present(makeConfirmationAlert(), animated: true)
    }

    private func makeConfirmationAlert() -> UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(title: StringLiteral.confirmButtonTitle) { [weak self] _ in
            guard let text = self?.noteInputView.textView.text,
                  let saveStatus = self?.viewModel.saveNote(withImage: self?.noteInputView.photo, text: text)
            else {
                return
            }

            switch saveStatus {
            case .success(let note):
                self?.delegate?.newNoteDidSave(note)
                self?.navigationController?.popToRootViewControllerWithFade()
            case .failure(let error):
                self?.presentSaveFailureAlert(withDescription: error.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction.cancelAction { [weak self] _ in
            self?.noteInputView.textView.becomeFirstResponder()
        }

        return .basic(
            alertTitle: StringLiteral.saveConfirmationAlertTitle,
            alertMessage: StringLiteral.saveConfirmationAlertMessage,
            confirmAction: confirmAction,
            cancelAction: cancelAction
        )
    }

    private func presentSaveFailureAlert(withDescription description: String) {
        let alert = UIAlertController.basic(
            alertTitle: StringLiteral.saveFailureAlertTItle,
            alertMessage: description,
            preferredStyle: .alert,
            confirmAction: .confirmAction()
        )
        self.present(alert, animated: true)
    }


    // MARK: - View Configuration Functions

    private func configureViews() {
        self.configureSubviews()
        self.configureConstraints()
        self.observeKeyboardAppearnce()
    }

    private func configureSubviews() {
        self.view.addSubview(self.noteInputView)
        self.noteInputView.backgroundNoteImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundDidTap(_:))
        ))
        self.updateColor()
        self.configureTextView()
        self.configureCalendarButton()
        self.updateLetterCountLabel(count: .zero)
        self.noteInputView.removePhotoButton.addAction(UIAction(handler: { [weak self] _ in
            self?.noteInputView.photo = nil
            self?.viewModel.newNote.imageID = nil
            self?.toolbar.photoButton.isEnabled = true
        }), for: .touchUpInside)
    }

    @objc private func backgroundDidTap(_ sender: UITapGestureRecognizer) {
        self.noteInputView.textView.resignFirstResponder()

        self.toolbarBottomConstraint?.update(inset: Int.zero)
        let toolbarHeight = self.toolbar.frame.height

        self.noteInputViewBotttomConstraint?.deactivate()
        self.noteInputView.snp.makeConstraints {
            self.noteInputViewBotttomConstraint = $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
                .inset(toolbarHeight)
                .priority(.high)
                .constraint
        }
    }

    private func updateColor() {
        self.view.backgroundColor = self.viewModel.backgroundColor
        self.noteInputView.backgroundNoteImageView.tintColor = self.viewModel.lineColor
        self.noteInputView.calendarButton.tintColor = self.viewModel.textColor
        self.noteInputView.letterCountLabel.textColor = self.viewModel.textColor
        self.updateCalendarButtonTitleText()
    }

    private func configureCalendarButton() {
        let action = UIAction { [weak self] _ in
            print("move to date select view controller ")
            self?.navigationController?.pushViewControllerWithFade(to: UIViewController())
            self?.noteInputView.textView.resignFirstResponder()
        }
        self.noteInputView.calendarButton.addAction(action, for: .touchUpInside)
        self.updateCalendarButtonTitleText()
    }

    private func updateCalendarButtonTitleText() {
        let calendarButton = self.noteInputView.calendarButton
        let customFont = (calendarButton.customFont ?? .current)
        let fontSize = calendarButton.titleLabel?.font.pointSize ?? FontSize.body3
        let font = UIFont(name: customFont.regular, size: fontSize) ?? .systemFont(ofSize: fontSize)
        let boldFont = UIFont(name: customFont.bold, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        let title = "  \(viewModel.yearString) \(viewModel.dateString)"
            .nsMutableAttributedStringify()
            .color(color: viewModel.textColor ?? .black)
            .font(font)
            .bold(font: boldFont, targetString: viewModel.yearString)

        self.noteInputView.calendarButton.setAttributedTitle(title, for: .normal)
    }

    private func configureTextView() {
        self.noteInputView.textView.delegate = self
        self.noteInputView.textView.becomeFirstResponder()
    }

    private func updateLetterCountLabel(count: Int) {
        let label = self.noteInputView.letterCountLabel
        let customFont = (label.customFont ?? .current)
        let fontSize = label.font.pointSize
        let font = UIFont(name: customFont.regular, size: fontSize) ?? .systemFont(ofSize: fontSize)
        let boldFont = UIFont(name: customFont.bold, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        let isLongerThanLimit = self.noteInputView.textView.text.count > Metric.noteTextMaxLength
        let countColor = isLongerThanLimit ? AssetColor.etcAlert : self.viewModel.textColor

        let title = "\(count) / \(Metric.noteTextMaxLength)"
            .nsMutableAttributedStringify()
            .color(color: self.viewModel.textColor ?? .black)
            .color(targetString: count.description, color: countColor ?? .black)
            .font(font)
            .bold(font: boldFont, targetString: count.description)

        self.noteInputView.letterCountLabel.attributedText = title
    }

    func attributedLetterCountString(count: Int) -> NSMutableAttributedString {
        let label = self.noteInputView.letterCountLabel
        let customFont = (label.customFont ?? .current)
        let fontSize = label.font.pointSize
        let font = UIFont(name: customFont.regular, size: fontSize) ?? .systemFont(ofSize: fontSize)
        let boldFont = UIFont(name: customFont.bold, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        let color = viewModel.textColor ?? .black

        return "\(count) / \(Metric.noteTextMaxLength)"
            .nsMutableAttributedStringify()
            .color(color: color)
            .font(font)
            .bold(font: boldFont, targetString: count.description)
    }

    private func configureConstraints() {
        self.noteInputView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            self.noteInputViewBotttomConstraint = $0.bottom.equalTo(self.view.safeAreaLayoutGuide).constraint
        }
    }

    private func observeKeyboardAppearnce() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: self.updateRelatedConstraints(notification:)
        )
    }

    /// 키보드에 맞춰 noteInputView의 길이와 toolbar의 위치 변경
    private func updateRelatedConstraints(notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardHeight = keyboardFrame.height - self.view.safeAreaInsets.bottom
        self.toolbarBottomConstraint?.update(inset: keyboardHeight)

        let toolbarHeight = self.toolbar.frame.height
        self.noteInputViewBotttomConstraint?.deactivate()
        self.noteInputView.snp.makeConstraints {
            self.noteInputViewBotttomConstraint = $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
                .inset(keyboardHeight + toolbarHeight)
                .constraint
        }
    }


    // MARK: - Toolbar Configuration Functions

    private func configureToolbar() {
        self.view.addSubview(self.toolbar)
        self.toolbar.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            self.toolbarBottomConstraint = $0.bottom.equalTo(self.view.safeAreaLayoutGuide).constraint
        }
        self.toolbar.photoButton.addAction(UIAction { [weak self] _ in
            self?.presentPhotoPicker() }, for: .touchUpInside)
        self.toolbar.colorPicker.delegate = self
    }

    private func presentPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.noteInputView.textView.resignFirstResponder()
        self.present(picker, animated: true)
    }
}


// MARK: - UITextViewDelegate
extension NewNoteInputViewController: UITextViewDelegate {

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
            self.noteInputView.warningLabel.fadeOut()
        }

        let updatedTextLength = textView.text.count - range.length + text.count
        let trimLength = updatedTextLength - Metric.krOverflowCap

        guard updatedTextLength > Metric.krOverflowCap,
              text.count >= trimLength
        else {
            /// 내용이 빈 상태에서 백스페이스를 누르는 경우
            if textView.text.isEmpty, text.isEmpty {
                self.noteInputView.placeholderLabel.fadeIn()
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
        let placeholderLabel = self.noteInputView.placeholderLabel
        if textView.text.isEmpty {
            placeholderLabel.fadeIn()
        } else {
            placeholderLabel.fadeOut()
        }
        self.updateLetterCountLabel(count: textView.text.count)

        // FIXME: Scroll to bottom if possible
    }
}


// MARK: - ColorPickerDelegate
extension NewNoteInputViewController: ColorPickerDelegate {
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
extension NewNoteInputViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        self.noteInputView.textView.becomeFirstResponder()

        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self)
        else {
            noteInputView.photo = results.isEmpty ? nil : .error
            viewModel.newNote.imageID = nil
            self.toolbar.photoButton.isEnabled = results.isEmpty
            return
        }

        let saveButton = self.navigationItem.rightBarButtonItem
        saveButton?.isEnabled = false

        // TODO: Use Progress View
        _ = result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self, saveButton] object, _ in
            DispatchQueue.main.async {
                saveButton?.isEnabled = true
                self?.toolbar.photoButton.isEnabled = false

                guard let image = object as? UIImage
                else {
                    self?.viewModel.newNote.imageID = nil
                    self?.noteInputView.photo = .error
                    return
                }

                self?.noteInputView.photo = image
                self?.viewModel.newNote.imageID = result.assetIdentifier ?? UUID().uuidString
            }
        }
    }
}


// MARK: - Constants
fileprivate extension NewNoteInputViewController {
    enum Metric {
        /// note 의 최대 작성 가능 길이 : 100 자
        static let noteTextMaxLength = 100

        /// 한국 글자수 제한을 위한 오버플로우 cap 추가 값: 1
        static let krOverflowCap = noteTextMaxLength + 1

        /// 애니메이션 지속 시간: 0.2
        static let animationDuration = 0.2
    }

    enum StringLiteral {

        /// 저장 확인 알림 제목
        static let saveConfirmationAlertTitle = "쪽지를 추가하시겠어요?"

        /// 저장 확인 알림 내용
        static let saveConfirmationAlertMessage = """
쪽지는 하루에 한 번 작성할 수 있고,
추가 후에는 수정/삭제가 불가능합니다
"""
        /// 저장 실패 알림 제목
        static let saveFailureAlertTItle = "저장에 실패했습니다"

        /// 확인 버튼 제목: "추가"
        static let confirmButtonTitle = "추가"
    }
}
