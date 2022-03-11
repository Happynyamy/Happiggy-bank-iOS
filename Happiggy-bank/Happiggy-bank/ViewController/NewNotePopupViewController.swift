//
//  NewNotePopupViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/22.
//

import UIKit

import Then

/// note 추가 팝업을 관리하는 뷰 컨트롤러
final class NewNotePopupViewController: UIViewController {
    
    // MARK: - Properties
    
    /// top bar container, note writing view, color palette container 를 담고 있는 스택 뷰
    private lazy var popupView = UIStackView().then {
        $0.frame = CGRect(origin: .zero, size: Metric.popupViewSize)
        $0.axis = .vertical
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Metric.popupCornerRadius
        $0.transform = CGAffineTransform(scaleX: Metric.transformScale, y: Metric.transformScale)
    }
    
    /// top bar 에 적절한 패딩을 설정하기 위한 컨테이너 뷰
    private lazy var topBarContainer = UIView().then {
        $0.frame = CGRect(origin: .zero, size: Metric.topbarContainerSize)
    }

    /// 취소, 저장 버튼과 팝업 제목을 담고 있는 상단 바
    private lazy var topBar = NewNotePopupTopBar().then {
        $0.frame = CGRect(origin: .zero, size: Metric.topBarSize)
    }
    
    /// color palette 에 적절한 패딩을 설정하기 위한 컨테이너 뷰
    private lazy var colorPaletteContainer = UIView().then {
        $0.frame = CGRect(origin: .zero, size: Metric.paletteContainerSize)
    }
    
    /// note 내용을 작성하는 textView
    private lazy var noteTextView = NoteTextView().then {
        $0.frame = CGRect(origin: .zero, size: Metric.noteTextViewSize)
        $0.backgroundColor = .white
        $0.delegate = self
    }
    
    /// note 의 선택 가능한 색상들
    private let noteColors = [UIColor.white]
    
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.congifureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fadeInWithScaleEffect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.fadeOut()
    }
    
    
    // MARK: - @objc
    
    /// save 버튼을 눌렀을 때 호출되는 메서드
    /// 서버에 새로운 note 관련 데이터를 전송하고,
    /// 필요시 home view 의 note progress label 과 bottle view 의 bottle 이미지 업데이트
    @objc private func saveButtonDidTap(_ sender: UIButton) {
        print("send new note data to server")
        self.post(name: .noteProgressDidUpdate)
        self.view.endEditing(true)
        self.dismiss()
    }
    
    /// cancel 버튼을 눌렀을 때 호출되는 메서드, 팝업을 닫음
    @objc private func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss()
    }
    
    /// 배경을 탭했을 때 호출되는 메서드
    /// 키보드가 올라와 있는 경우 키보드를 내리고, 키보드가 올라와 있지 않은 경우 팝업을 닫음
    @objc private func backgroundDidTap(_ sender: UITapGestureRecognizer) {
        if self.noteTextView.isFirstResponder {
            self.noteTextView.resignFirstResponder()
            return
        }
        if !self.noteTextView.isFirstResponder {
            self.dismiss()
        }
    }
    
    /// note text view 를 탭했을 때 호출되는 메서드
    /// 키보드가 올라와 있는 경우 키보드를 내리고, 올라와 있지 않은 경우 입력을 활성화하고 키보드를 올림
    @objc private func textViewDidTap(_ sender: UITapGestureRecognizer) {
        if self.noteTextView.isFirstResponder {
            self.noteTextView.resignFirstResponder()
            return
        }
        if !self.noteTextView.isFirstResponder {
            self.noteTextView.becomeFirstResponder()
        }
    }
    
    /// 배경이 아닌 팝업을 탭했을 때 호출되는 메서드
    /// 키보드가 올라와있을 때 버튼, 라벨, 텍스트 뷰 이외의 영역을 터치하면 키보드가 내려감
    /// 그 외의 상황에서는 탭 무시
    @objc private func contentViewDidTap(_ sender: UITapGestureRecognizer) {
        if self.noteTextView.isFirstResponder {
            self.noteTextView.resignFirstResponder()
        }
    }
    
    /// 컬러 팔레트에서 선택 색상이 변경되었을 때 호출되는 메서드
    /// 변경된 색상에 맞게 note text view 의 색상 변경
    /// 추후에 이미지 에셋 받으면 변경할 예정
    
    // MARK: - Functions
    
    /// 뷰 체계 관리 및 target-action 추가 등 init 시 설정한 사항 외의 작업 수행
    private func configureViews() {
        self.view.backgroundColor = .black.withAlphaComponent(Metric.blackAlpha)
        self.configureViewHierarchy()
        self.addTapGestureRecoginzers()
        self.configureTopBar()
    }
    
    /// 뷰 체계 관리
    private func configureViewHierarchy() {
        view.addSubview(popupView)
        
        popupView.addArrangedSubview(topBarContainer)
        popupView.addArrangedSubview(noteTextView)
        popupView.addArrangedSubview(colorPaletteContainer)

        topBarContainer.addSubview(topBar)
    }
    
    // Topbar 관련 설정 및 target-action 추가
    private func configureTopBar() {
        if self.noteTextView.text.isEmpty {
            self.topBar.saveButton.isEnabled = false
        }
        topBar.cancelButton.addTarget(
            self,
            action: #selector(cancelButtonDidTap(_:)),
            for: .touchUpInside
        )
        topBar.saveButton.addTarget(
            self,
            action: #selector(saveButtonDidTap(_:)),
            for: .touchUpInside
        )
    }

    /// 뷰들의 오토레이아웃 설정
    private func congifureConstraints() {
        configurePopupViewConstraints()
        configureTopBarContainerConstraints()
        configureTopBarConstraints()
        configureNoteTextViewConstraints()
        configureColorPaletteContainerConstraints()
    }
    
    /// 팝업 뷰의 오토레이아웃 설정
    private func configurePopupViewConstraints() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: Metric.popupViewSize.width),
            popupView.heightAnchor.constraint(equalToConstant: Metric.popupViewSize.height),
            popupView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Metric.popupViewTopAnchor
            ),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    /// note text view 오토레이아웃 설정
    private func configureNoteTextViewConstraints() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        noteTextView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            noteTextView.widthAnchor.constraint(equalTo: popupView.widthAnchor),
            noteTextView.heightAnchor.constraint(equalToConstant: Metric.noteTextViewSize.height)
        ])
    }
    
    /// top bar container 의 오토레이아웃 설정
    private func configureTopBarContainerConstraints() {
        topBarContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarContainer.widthAnchor.constraint(
                equalToConstant: Metric.topbarContainerSize.width
            ),
            topBarContainer.heightAnchor.constraint(
                equalToConstant: Metric.topbarContainerSize.height
            )
        ])
    }
    
    /// top bar 의 오토레이아웃 설정
    private func configureTopBarConstraints() {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.widthAnchor.constraint(equalToConstant: Metric.topBarSize.width),
            topBar.heightAnchor.constraint(equalToConstant: Metric.topBarSize.height),
            topBar.centerXAnchor.constraint(equalTo: topBarContainer.centerXAnchor),
            topBar.centerYAnchor.constraint(equalTo: topBarContainer.centerYAnchor)
        ])
    }

    /// palette container view 의 오토레이아웃 설정
    private func configureColorPaletteContainerConstraints() {
        colorPaletteContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPaletteContainer.widthAnchor.constraint(
                equalToConstant: Metric.paletteContainerSize.width
            ),
            colorPaletteContainer.heightAnchor.constraint(
                equalToConstant: Metric.paletteContainerSize.height
            )
        ])
    }
            
    /// 화면을 탭하면 현재 상태, 터치한 부분에 따라 필요한 반응을 하도록 tap gesture recognizer 들을 추가
    private func addTapGestureRecoginzers() {
        self.view.addGestureRecognizer(tapGestureRecognizer(
            action: #selector(backgroundDidTap(_:)))
        )
        self.popupView.addGestureRecognizer(tapGestureRecognizer(
            action: #selector(contentViewDidTap(_:)))
        )
        self.noteTextView.addGestureRecognizer(tapGestureRecognizer(
            action: #selector(textViewDidTap(_:)))
        )
    }
    
    /// tap gesture recognizer 를 생성
    private func tapGestureRecognizer(action: Selector) -> UITapGestureRecognizer {
        UITapGestureRecognizer(target: self, action: action)
    }
    
    /// 현재 띄워져 있는 view controller 를 종료
    private func dismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    /// 팝업이 나타날 때 페이드인 효과와 Scale 효과를 줌
    private func fadeInWithScaleEffect() {
        self.popupView.alpha = 0
        
        UIView.animate(
            withDuration: Metric.animationDuration,
            delay: 0,
            options: .curveEaseInOut
        ) { [weak self] in
            self?.popupView.alpha = 1
            self?.popupView.transform = .identity
            self?.view.isHidden = false
        }
    }
    
//    /// 팝업이 사라질 때 페이드아웃 효과를 줌
//    private func fadeOut() {
//        self.view.window!.layer.add(CATransition.fadeTransition(), forKey: kCATransition)
//        self.view.isHidden = true
//    }
    
    /// 현재 글자수 라벨을 업데이트
    private func updateLetterCountLabel(count: Int) {
        noteTextView.letterCountLabel.text = "\(count)" + StringLiteral.maximumLetterCount
    }
}


// MARK: - UITextViewDelegate

extension NewNotePopupViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.noteTextView.placeholder.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.noteTextView.text = nil
            self.noteTextView.placeholder.isHidden = false
            self.topBar.saveButton.isEnabled = false
            self.updateLetterCountLabel(count: 0)
            return
        }
        
        if textView.text.count > Metric.noteTextMaxLength {
            textView.deleteBackward()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let currentText = textView.text,
              let updateRange = Range(range, in: currentText)
        else { return false }

        var newText = currentText.replacingCharacters(in: updateRange, with: text)
        
        var overflowCap = Metric.noteTextMaxLength
        if textView.textInputMode?.primaryLanguage == StringLiteral.korean {
            overflowCap += 1
        }
        
        if newText.count > overflowCap {
            guard let overflowRange = Range(
                NSRange(
                    location: Metric.noteTextMaxLength,
                    length: newText.count - Metric.noteTextMaxLength
                ),
                in: newText
            )
            else { return false }
            newText.removeSubrange(overflowRange)
            self.noteTextView.text = newText
            updateLetterCountLabel(count: self.noteTextView.text.count)
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateLetterCountLabel(count: textView.text.count)
        
        if textView.text.isEmpty {
            self.topBar.saveButton.isEnabled = false
            return
        }
        if !textView.text.isEmpty {
            self.topBar.saveButton.isEnabled = true
        }
    }
}
