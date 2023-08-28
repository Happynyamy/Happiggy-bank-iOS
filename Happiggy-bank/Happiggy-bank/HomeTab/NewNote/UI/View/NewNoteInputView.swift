//
//  NewNoteInputView.swift
//  NoteViewPractice
//
//  Created by sun on 2022/10/19.
//

import UIKit

import SnapKit
import Then

/// 쪽지 작성 시 나타나는 뷰
final class NewNoteInputView: UIScrollView {

    // MARK: - Properties

    var photo: UIImage? {
        get { self.photoView.image }
        set {
            self.removablePhotoView.isHidden = newValue == nil
            self.photoView.image = newValue
        }
    }

    /// 배경이 되는 쪽지 이미지 뷰
    let backgroundNoteImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        let inset = UIEdgeInsets(
            top: Metric.spacing16,
            left: Metric.spacing16,
            bottom: Metric.spacing16,
            right: Metric.spacing16
        )
        $0.image = AssetImage.noteLine?.resizableImage(withCapInsets: inset, resizingMode: .stretch)
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    /// 날짜 피커를 띄우는 버튼
    let calendarButton = BaseButton().then {
        $0.setImage(AssetImage.calendar, for: .normal)
        $0.titleLabel?.changeFontSize(to: FontSize.body3)
        $0.adjustsImageWhenHighlighted = false
    }

    /// 유저가 선택한 사진을 제거하는 버튼
    let removePhotoButton = BaseButton().then {
        $0.setImage(AssetImage.deleteImage, for: .normal)
    }

    /// 쪽지 내용을 작성하는 텍스트 뷰
    let textView = BaseTextView().then {
        $0.font = $0.font?.withSize(FontSize.body1)
        $0.configureParagraphStyle(
            lineSpacing: ParagraphStyle.lineSpacing,
            characterSpacing: ParagraphStyle.characterSpacing
        )
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    /// 쪽지 텍스트 뷰의 플레이스 홀더
    let placeholderLabel = BaseLabel().then {
        $0.textColor = AssetColor.noteWhiteText
        $0.changeFontSize(to: FontSize.body1)
        $0.configureParagraphStyle(
            lineSpacing: ParagraphStyle.lineSpacing,
            characterSpacing: ParagraphStyle.characterSpacing
        )
        $0.attributedText = NSAttributedString(string: StringLiteral.placeholder)
    }

    /// 내용이 비었음을 경고하는 레이블
    let warningLabel = BaseLabel().then {
        $0.textColor = AssetColor.etcAlert
        $0.changeFontSize(to: FontSize.body1)
        $0.configureParagraphStyle(
            lineSpacing: ParagraphStyle.lineSpacing,
            characterSpacing: ParagraphStyle.characterSpacing
        )
        $0.attributedText = NSAttributedString(string: StringLiteral.warning)
        $0.isHidden = true
    }

    /// 쪽지 글자 수를 나타내는 레이블
    let letterCountLabel = BaseLabel().then {
        $0.text = .empty
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.sizeToFit()
        $0.changeFontSize(to: FontSize.body3)
        $0.configureParagraphStyle(
            lineSpacing: ParagraphStyle.lineSpacing,
            characterSpacing: ParagraphStyle.characterSpacing
        )
        $0.textAlignment = .right
    }

    /// 캘린더 버튼 태그, 텍스트뷰, 글자 수 레이블이 들어가는 스택 뷰
    private let contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.spacing16
    }

    private let calendarStack = UIStackView()

    private let calendarStackSpacer = UIView()

    /// photoView와 removePhotoButton을 하위 뷰로 갖는 뷰
    private let removablePhotoView = UIView().then {
        $0.isHidden = true
    }

    /// 유저가 선택한 사진을 띄우는 이미지 뷰
    private let photoView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureViews()
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.configureSubviews()
        self.configureConstraints()
    }

    private func configureSubviews() {
        self.addSubview(backgroundNoteImageView)
        self.backgroundNoteImageView.addSubview(self.contentStack)
        self.contentStack.addArrangedSubviews(
            self.calendarStack,
            self.removablePhotoView,
            self.textView,
            self.letterCountLabel
        )
        self.calendarStack.addArrangedSubviews(self.calendarButton, self.calendarStackSpacer)
        self.removablePhotoView.addSubviews(self.photoView, self.removePhotoButton)
        self.textView.addSubviews(self.placeholderLabel, self.warningLabel)
    }

    private func configureConstraints() {
        self.backgroundNoteImageView.snp.makeConstraints {
            $0.edges.equalTo(self.contentLayoutGuide)
            $0.width.equalTo(self.frameLayoutGuide)
            $0.height.equalTo(self.frameLayoutGuide).priority(.low)
        }
        self.contentStack.snp.makeConstraints {
            $0.edges.equalTo(self.backgroundNoteImageView).inset(Metric.spacing24)
        }
        self.calendarStack.snp.makeConstraints { $0.height.equalTo(Metric.spacing24) }
        self.photoView.snp.makeConstraints {
            $0.verticalEdges.centerX.equalTo(self.removablePhotoView)
            $0.width.equalTo(self.photoView.snp.height).multipliedBy(CGFloat.one)
            $0.horizontalEdges.equalTo(self.backgroundNoteImageView).inset(Metric.spacing75)
        }
        self.removePhotoButton.snp.makeConstraints {
            $0.width.height.equalTo(Metric.spacing24)
            $0.top.right.equalTo(self.photoView).inset(Metric.spacing10)
        }
        self.placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(self.textView).offset(Metric.spacing9)
            $0.leading.equalTo(self.textView).offset(Metric.spacing5)
        }
        self.warningLabel.snp.makeConstraints { $0.top.leading.equalTo(self.placeholderLabel) }
    }
}


// MARK: - Constants
fileprivate extension NewNoteInputView {

    enum Metric {
        static let spacing5: CGFloat = 5
        static let spacing9: CGFloat = 9
        static let spacing10: CGFloat = 10
        static let spacing16: CGFloat = 16
        static let spacing24: CGFloat = 24
        static let spacing75: CGFloat = 75
    }

    enum StringLiteral {
        static let placeholder = "하루 한 번, 100자로 행복을 기록하세요:)"
        static let warning = "내용을 입력해주세요!"
    }
}
