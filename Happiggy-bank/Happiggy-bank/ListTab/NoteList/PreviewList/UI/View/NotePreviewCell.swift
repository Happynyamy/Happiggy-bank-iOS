//
//  NotePreviewCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/25.
//

import UIKit

import SnapKit
import Then

/// NoteDetailListView 에서 사용하는 셀
final class NotePreviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// 첫 단어 라벨
    let firstWordLabel = BaseLabel().then {
        $0.textAlignment = .center
        $0.changeFontSize(to: FontSize.body1)
        $0.bold()
    }
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureHierarchy()
        self.configureFirstWordLabelConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Override Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.firstWordLabel.attributedText = nil
        self.transform = .identity
    }
    
    
    // MARK: - Functions
    
    /// 뷰 체계 설정
    private func configureHierarchy() {
        self.contentView.addSubview(self.firstWordLabel)
    }
    
    /// 단어 라벨 오토레이아웃
    private func configureFirstWordLabelConstraints() {
        self.firstWordLabel.snp.makeConstraints { $0.edges.equalTo(self.contentView) }
    }
}
