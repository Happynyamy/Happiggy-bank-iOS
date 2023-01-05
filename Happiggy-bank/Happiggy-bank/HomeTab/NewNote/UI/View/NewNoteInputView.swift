//
//  NewNoteInputView.swift
//  NoteViewPractice
//
//  Created by sun on 2022/10/19.
//

import UIKit

/// 쪽지 작성 시 나타나는 뷰
@IBDesignable
final class NewNoteInputView: UIView {

    // MARK: - @IBOulets

    var photo: UIImage? {
        get { self.photoView.image }
        set {
            self.removablePhotoView.isHidden = newValue == nil
            self.photoView.image = newValue
        }
    }

    /// 배경이 되는 쪽지 이미지 뷰
    @IBOutlet weak var backgroundNoteImageView: UIImageView!

    /// 날짜 피커를 띄우는 버튼
    @IBOutlet weak var dateButton: UIButton!

    /// 유저가 선택한 사진을 띄우는 이미지 뷰
    @IBOutlet weak var photoView: UIImageView!

    /// 유저가 선택한 사진을 제거하는 버튼
    @IBOutlet weak var removePhotoButton: UIButton!

    /// 쪽지 텍스트 뷰의 플레이스 홀더
    @IBOutlet weak var placeholderLabel: UILabel!

    /// 내용이 비었음을 경고하는 레이블
    @IBOutlet weak var warningLabel: UILabel!
    
    /// 쪽지 내용을 작성하는 텍스트 뷰
    @IBOutlet weak var textView: UITextView!

    /// 쪽지 글자 수를 나타내는 레이블
    @IBOutlet weak var letterCountLabel: UILabel!

    /// 모든 하위 뷰를 담고 있는 스크롤 뷰
    @IBOutlet weak private var scrollView: UIScrollView!

    /// photoView와 removePhotoButton을 하위 뷰로 갖는 뷰
    @IBOutlet weak var removablePhotoView: UIView!


    // MARK: Properties

    /// 내용의 길이(높이)
    var contentHeight: CGFloat {
        self.scrollView.contentSize.height
    }


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configure()
    }


    // MARK: - Funtions

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    /// 뷰 초기 설정
    private func configure() {
        self.configureXib()
        self.configureTextView()
        self.configureLabels(self.placeholderLabel, self.warningLabel)
        self.photoView.contentMode = .scaleAspectFill
    }

    /// 텍스트 뷰 관련 초기 설정
    private func configureTextView() {
        self.textView.configureParagraphStyle(
            lineSpacing: ParagraphStyle.lineSpacing,
            characterSpacing: ParagraphStyle.characterSpacing
        )
    }

    /// 플레이스홀더 라벨 초기 설정
    private func configureLabels(_ labels: UILabel...) {
        labels.forEach {
            $0.configureParagraphStyle(
                lineSpacing: ParagraphStyle.lineSpacing,
                characterSpacing: ParagraphStyle.characterSpacing
            )
        }
    }
}
