//
//  PhotoNoteCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/11/06.
//

import UIKit

import Then

// 쪽지 디테일 뷰에서 사용하는 이미지를 나타낼 수 있는 쪽지 셀
final class PhotoNoteCell: UITableViewCell {

    // MARK: - Properties

    var viewModel: PhotoNoteCellViewModel? {
        didSet { self.render() }
    }

    /// 셀 간 여백 설정을 위한 뷰
    private let validView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    /// 작성 날짜 레이블
    private let dateLabel = UILabel().then {
        $0.changeFontSize(to: FontSize.secondaryLabel)
    }

    /// 몇 번째 쪽지인지 나타내는 레이블
    private let indexLabel = UILabel().then {
        $0.changeFontSize(to: FontSize.secondaryLabel)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.textColor = .customGray
    }

    /// 저장한 사진을 나타내는 이미지 뷰
    private let photoView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Metric.photoCornerRadius
        $0.layer.borderWidth = Metric.photoBorderWidth
        $0.layer.borderColor = UIColor.reversedLabel.cgColor
        $0.isUserInteractionEnabled = true
    }

    /// 내용 레이블
    private let contentLabel = UILabel().then {
        $0.changeFontSize(to: FontSize.body)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = .zero
        $0.textColor = .black
    }

    /// 배경 이미지 뷰
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage.borderedNoteBackground?.resizableImage(
            withCapInsets: Metric.imageCapInsets,
            resizingMode: .stretch
        )
        $0.autoresizingMask.update(with: [.flexibleWidth, .flexibleHeight])
    }

    /// 날짜와 인덱스 레이블을 담고 있는 스택 뷰
    private let dateAndIndexStack = UIStackView()

    /// 모든 UI 요소를 담고 있는 스택 뷰
    private let contentStack = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = Metric.spacing
    }


    // MARK: - Init(s)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureViews()
    }


    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.viewModel = nil
    }


    // MARK: - Functions

    /// 셀을 내용을 채우는 메서드
    private func render() {
        self.validView.backgroundColor = self.viewModel?.basicColor
        self.backgroundImageView.tintColor = self.viewModel?.borderColor
        self.dateLabel.attributedText = self.viewModel?.attributedDateString
        self.indexLabel.attributedText = self.viewModel?.attributedIndexString
        self.contentLabel.attributedText = self.viewModel?.attributedContentString
        self.contentLabel.configureParagraphStyle(font: .systemFont(ofSize: FontSize.body))
        self.photoView.image = self.viewModel?.photo()
        self.photoView.isHidden = self.viewModel?.photo == nil
    }

    /// 뷰 초기 설정
    private func configureViews() {
        self.selectionStyle = .none
        self.configureViewHierarchy()
        self.configureViewLayout()
        self.configurePhotoView()
    }

    /// 하위 뷰 추가
    private func configureViewHierarchy() {
        self.contentView.addSubview(self.validView)
        self.validView.addSubviews(self.backgroundImageView, self.contentStack)
        let contentStackSubviews = [self.dateAndIndexStack, self.photoView, self.contentLabel]
        self.contentStack.addArrangedSubviews(contentStackSubviews)
        self.dateAndIndexStack.addArrangedSubviews(self.dateLabel, self.indexLabel)
    }

    /// 뷰 레이아웃 설정
    private func configureViewLayout() {
        self.configureValidViewLayout()
        self.configureBackgroundImageViewLayout()
        self.configureContentStackLayout()
        self.configurePhotoViewLayout()
    }

    /// 셀 간 간격이 있는 것처럼 나타내기 위해 validView의 레이아웃을 설정
    private func configureValidViewLayout() {
        NSLayoutConstraint.activate([
            self.validView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.validView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -Metric.spacing
            ),
            self.validView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor
            ),
            self.validView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor
            )
        ])
    }

    /// backgroundImageView 레이아웃 설정
    private func configureBackgroundImageViewLayout() {
        self.backgroundImageView.frame = self.validView.bounds
    }

    /// contentStack 레이아웃 설정
    private func configureContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(
                equalTo: self.validView.topAnchor,
                constant: Metric.inset
            ),
            contentStack.bottomAnchor.constraint(
                equalTo: self.validView.bottomAnchor,
                constant: -Metric.inset
            ),
            contentStack.leadingAnchor.constraint(
                equalTo: self.validView.leadingAnchor,
                constant: Metric.inset
            ),
            contentStack.trailingAnchor.constraint(
                equalTo: self.validView.trailingAnchor,
                constant: -Metric.inset
            )
        ])
    }

    /// photoView 레이아웃 설정
    private func configurePhotoViewLayout() {
        NSLayoutConstraint.activate([
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor)
        ])
    }

    /// photoView에 tapGestureRecognizer 추가
    private func configurePhotoView() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.photoDidTap(_:))
        )
        self.photoView.addGestureRecognizer(tapGestureRecognizer)
    }

    /// 사진을 탭했을 때 호출
    @objc private func photoDidTap(_ sender: UITapGestureRecognizer) {
        guard let photo = self.photoView.image,
              photo != .error ?? UIImage()
        else {
            return
        }
        self.viewModel?.photoDidTap?(photo)
    }
}


// MARK: - Constants
fileprivate extension PhotoNoteCell {

    /// 상수
    enum Metric {

        /// 사진 테두리 둥근 정도
        static let photoCornerRadius:  CGFloat = 8

        /// 사진 테두리 굵기
        static let photoBorderWidth: CGFloat = 1

        /// 간격: 16
        static let spacing: CGFloat = 16

        /// 상하좌우 여백: 24
        static let inset: CGFloat = 24

        /// 배경 이미지의 UIEdgeInsets: (15, 15, 15, 15)
        static let imageCapInsets = UIEdgeInsets(
            top: imageInset,
            left: imageInset,
            bottom: imageInset,
            right: imageInset
        )

        /// 배경 이미지 고정 inset 값: 15
        private static let imageInset: CGFloat = 15
    }
}
