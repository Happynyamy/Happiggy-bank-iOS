//
//  NewNoteDatePickerRowView.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새로운 쪽지 추가 시 사용하는 날짜 피커의 각 행을 나타내는 뷰
final class NewNoteDatePickerRowView: UIView {

    // MARK: - Properties

    /// 해당 날짜에 쪽지를 썼는지 나타낼 이미지 뷰
    let noteImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
    }

    let dateLabel = BaseLabel().then {
        $0.changeFontSize(to: FontSize.body1)
    }

    private let contentStack = UIStackView().then {
        $0.spacing = Metric.spacing11
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
        self.configureSubviews()
        self.configureConstraints()
    }

    private func configureSubviews() {
        self.addSubview(self.contentStack)
        self.contentStack.addArrangedSubviews(self.noteImageView, self.dateLabel)
    }

    private func configureConstraints() {
        self.contentStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(Metric.spacing4)
        }
        self.dateLabel.snp.makeConstraints { $0.centerX.equalTo(self) }
        self.noteImageView.snp.makeConstraints {
            $0.width.equalTo(self.noteImageView.snp.height).multipliedBy(CGFloat.one)
        }
    }
}


// MARK: - Constants
fileprivate extension NewNoteDatePickerRowView {

    enum Metric {
        static let spacing4: CGFloat = 4
        static let spacing11: CGFloat = 11
    }
}
