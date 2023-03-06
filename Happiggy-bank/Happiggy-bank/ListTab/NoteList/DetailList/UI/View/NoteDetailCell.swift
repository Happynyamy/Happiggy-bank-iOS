//
//  NoteDetailCell.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/06.
//

import UIKit

import SnapKit
import Then

/// NoteDetailList에서 사용하는 쪽지의 세부 내용을 확인할 수 있는 컬렉션 뷰 셀
///
/// viewModel 변수를 설정하면 해당 viewModel이 담고 있는 데이터에 맞게 UI 요소들을 업데이트함
final class NoteDetailCell: UICollectionViewCell {

    // MARK: - Properties

    /// 새로운 인스턴스를 지정하면 UI 요소들이 바로 업데이트 됨
    var viewModel: NoteDetailCellViewModel? {
        didSet { self.render() }
    }

    /// 작성 날짜 레이블
    private let dateLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.secondaryLabel)
    }

    /// 몇 번째 쪽지인지 나타내는 레이블
    private let indexLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.secondaryLabel)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    /// 저장한 사진을 나타내는 이미지 뷰
    private let photoView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Metric.photoCornerRadius
        $0.layer.borderWidth = Metric.photoBorderWidth
        $0.layer.borderColor = UIColor.systemBackground.cgColor
        $0.isUserInteractionEnabled = true
    }

    /// 내용 레이블
    private let contentLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = .zero
        $0.textColor = .black
    }

    /// 날짜와 인덱스 레이블을 담고 있는 스택 뷰
    private let dateAndIndexStack = UIStackView()

    /// 배경 이미지 뷰
    private let backgroundImageView = UIImageView().then {
        $0.image = AssetImage.noteLine?.resizableImage(
            withCapInsets: Metric.imageCapInsets,
            resizingMode: .stretch
        )
        $0.autoresizingMask.update(with: [.flexibleWidth, .flexibleHeight])
    }

    /// 배경 이미지 뷰를 제외한 모든 UI 요소를 담고 있는 스택 뷰
    private let contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.spacing16
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


    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.viewModel = nil
        self.photoView.layer.borderColor = UIColor.systemBackground.cgColor
    }


    // MARK: - Functions

    /// 셀의 내용을 채우는 메서드
    private func render() {
        self.contentView.backgroundColor = self.viewModel?.backgroundColor
        self.backgroundImageView.tintColor = self.viewModel?.lineColor
        self.dateLabel.attributedText = self.createAttributedDateString()
        self.indexLabel.attributedText = self.createAttributedIndexString()
        self.contentLabel.attributedText = self.viewModel?.contentString.nsMutableAttributedStringify()
        self.contentLabel.configureParagraphStyle(font: self.contentLabel.font)
        self.photoView.image = self.viewModel?.photo()
        self.photoView.isHidden = self.viewModel?.hasPhoto != true
    }

    private func createAttributedDateString() -> NSAttributedString? {
        guard let viewModel
        else {
            return nil
        }

        let customFont = (self.dateLabel.customFont ?? .current)
        let fontSize = self.dateLabel.font.pointSize
        let font = UIFont(name: customFont.regular, size: fontSize) ?? .systemFont(ofSize: fontSize)
        let boldFont = UIFont(name: customFont.bold, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        let color = viewModel.textColor ?? .black

        return "\(viewModel.yearString) \(viewModel.dateString)"
            .nsMutableAttributedStringify()
            .color(color: color)
            .font(font)
            .bold(font: boldFont, targetString: viewModel.yearString)
    }

    private func createAttributedIndexString() -> NSAttributedString? {
        guard let viewModel
        else {
            return nil
        }

        let customFont = (self.dateLabel.customFont ?? .current)
        let fontSize = self.dateLabel.font.pointSize
        let font = UIFont(name: customFont.regular, size: fontSize) ?? .systemFont(ofSize: fontSize)
        let boldFont = UIFont(name: customFont.bold, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        let color = viewModel.textColor ?? .black
        let indexString = viewModel.index.description
        let slashString = "/\(viewModel.numberOfTotalNotes)"

        return "\(indexString)\(slashString)"
            .nsMutableAttributedStringify()
            .color(color: color)
            .font(font)
            .bold(font: boldFont, targetString: indexString)
    }

    /// 뷰 초기 설정
    private func configureViews() {
        self.configureViewHierarchy()
        self.configureViewLayout()
        self.configurePhotoView()
    }

    /// 하위 뷰 추가
    private func configureViewHierarchy() {
        self.contentView.addSubviews(self.backgroundImageView, self.contentStack)
        let contentStackSubviews = [self.dateAndIndexStack, self.photoView, self.contentLabel]
        self.contentStack.addArrangedSubviews(contentStackSubviews)
        self.dateAndIndexStack.addArrangedSubviews(self.dateLabel, self.indexLabel)
    }

    /// 뷰 레이아웃 설정
    private func configureViewLayout() {
        self.contentStack.snp.makeConstraints {
            $0.edges.equalTo(self.contentView).inset(Metric.spacing24)
        }
        self.backgroundImageView.frame = self.contentView.bounds
        self.photoView.snp.makeConstraints {
            $0.width.equalTo(photoView.snp.height).multipliedBy(CGFloat.one)
        }
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
fileprivate extension NoteDetailCell {

    /// 상수
    enum Metric {
        static let photoCornerRadius:  CGFloat = 8
        static let photoBorderWidth: CGFloat = 1
        static let spacing16: CGFloat = 16
        static let spacing24: CGFloat = 24
        static let imageCapInsets = UIEdgeInsets(
            top: imageInset,
            left: imageInset,
            bottom: imageInset,
            right: imageInset
        )
        private static let imageInset: CGFloat = 15
    }
}
