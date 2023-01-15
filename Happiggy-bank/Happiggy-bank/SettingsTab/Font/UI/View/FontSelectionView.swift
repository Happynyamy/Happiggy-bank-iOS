//
//  FontSelectionView.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/05.
//

import UIKit

import SnapKit
import Then

final class FontSelectionView: UIView {

    // MARK: - Properties

    /// 선택한 폰트를 나타내는 레이블
    let fontNameLabel = BaseLabel().then {
        $0.textAlignment = .center
        $0.bold()
        $0.changeFontSize(to: FontSize.body1)
    }

    /// 선택한 폰트로 예시 문구를 나타내는 레이블
    let exampleLabel = BaseLabel().then {
        $0.text = StringLiteral.exampleText
        $0.numberOfLines = .zero
        $0.configureParagraphStyle(lineSpacing: Metric.lineSpacing)
        $0.textAlignment = .center
        $0.changeFontSize(to: FontSize.body1)
    }

    /// 선택할 수 있는 폰트들을 나타내는 테이블 뷰
    let listView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = AssetColor.etcTextBox
        $0.layer.cornerRadius = Metric.cornerRadius
        
        let numberOfCustomFonts = CGFloat(CustomFont.allCases.count)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / numberOfCustomFonts)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Metric.itemHeight * numberOfCustomFonts)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: CustomFont.allCases.count
        )
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Metric.spacing16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: Metric.spacing16,
            leading: .zero,
            bottom: Metric.spacing16,
            trailing: .zero
        )

        $0.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }

    private let contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.spacing24
    }

    private let nameAndExampleStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.spacing16
    }

    private let nameAndExampleBackgroundImage = UIImageView(
        image: AssetImage.fontSelectionExampleBackground
    )


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.backgroundColor = .systemBackground
        self.configureSubviews()
        self.configureConstraints()
    }

    private func configureSubviews() {
        self.addSubview(self.contentStack)
        self.contentStack.addArrangedSubviews(self.nameAndExampleBackgroundImage, self.listView)
        self.nameAndExampleBackgroundImage.addSubview(nameAndExampleStack)
        self.nameAndExampleStack.addArrangedSubviews(self.fontNameLabel, self.exampleLabel)
    }

    private func configureConstraints() {
        self.contentStack.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide).inset(Metric.spacing24)
        }
        self.nameAndExampleBackgroundImage.snp.makeConstraints {
            $0.height.equalTo(Metric.imageHeight)
        }
        self.nameAndExampleStack.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}


// MARK: - Constants
fileprivate extension FontSelectionView {

    enum Metric {
        static let spacing24: CGFloat = 24
        static let spacing16: CGFloat = 16
        static let cornerRadius: CGFloat = 8
        static let imageHeight: CGFloat = 168
        static let lineSpacing: CGFloat = 4
        static let itemHeight: CGFloat = 41
    }

    enum StringLiteral {
        static let exampleText = "행복냠냠이\n123! Hello world:)"
    }
}
