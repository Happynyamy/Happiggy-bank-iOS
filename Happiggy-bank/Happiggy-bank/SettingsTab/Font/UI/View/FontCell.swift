//
//  FontCell.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/05.
//

import UIKit

/// 폰트 선택 화면에서 사용하는 셀
final class FontCell: UICollectionViewCell {

    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Updating Functions

    /// 선택 여부에 따라 셀의 색상 및 볼드 여부 업데이트
    /// - Parameters:
    ///   - font: 셀이 나타낼 CustomFont
    ///   - isCurrentFont: 셀이 나타낼 폰트가 유저가 선택한 폰트인지 나타내는 Bool 값
    func update(withCustomFont font: CustomFont, isCurrentFont: Bool) {
        var configuration = UIListContentConfiguration.cell()
        configuration.text = font.description
        configuration.textProperties.alignment = .center
        let textColor = isCurrentFont ? AssetColor.mainGreen : .label
        configuration.textProperties.color = textColor ?? .label
        let fontName = isCurrentFont ? font.bold : font.regular
        let font = UIFont(name: fontName, size: FontSize.body1) ?? .systemFont(ofSize: FontSize.body1)
        configuration.textProperties.font = font
        self.contentConfiguration = configuration
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.backgroundColor = AssetColor.etcTextBox
    }
}
