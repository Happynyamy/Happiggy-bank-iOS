//
//  LabeledCollectionView.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/05.
//

import UIKit

import SnapKit
import Then

/// 내용이 없거나 에러가 발생한 경우 안내 사항을 나타낼 레이블을 갖고 있는 컬렉션 뷰
final class LabeledCollectionView: UICollectionView {

    // MARK: - Properties

    /// 내용이 없거나 에러가 발생한 경우 안내 사항을 나타낼 레이블
    ///
    /// 폰트 크기 기본 값: 18
    let noticeLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body1)
    }


    // MARK: - Init(s)

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureViews()
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.configureSubviews()
        self.configureConstraints()
    }

    private func configureSubviews() {
        self.addSubview(self.noticeLabel)
    }

    private func configureConstraints() {
        self.noticeLabel.snp.makeConstraints { $0.center.equalTo(self.safeAreaLayoutGuide) }
    }
}
