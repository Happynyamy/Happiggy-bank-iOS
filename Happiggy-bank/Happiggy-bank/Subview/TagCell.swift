//
//  TagCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/25.
//

import UIKit

/// NoteCollectionView 에서 사용하는 셀
final class TagCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// 첫 단어 라벨
    let firstWordLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: Font.firstWordLabel)
        $0.textAlignment = .center
    }
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureHierarchy()
        self.configureFirstWordLabelConstraints()
    }
    
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
        self.firstWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.firstWordLabel)
    }
    
    /// 단어 라벨 오토레이아웃
    private func configureFirstWordLabelConstraints() {
        NSLayoutConstraint.activate([
            self.firstWordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.firstWordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
