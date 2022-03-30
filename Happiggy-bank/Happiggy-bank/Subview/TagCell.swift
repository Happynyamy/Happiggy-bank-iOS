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
        $0.font = .systemFont(ofSize: Font.firstWordLabel)
        $0.textAlignment = .center
    }
    
    /// 쪽지 배경 이미지
    let noteImageView = UIImageView()
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureHierarchy()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Override Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.noteImageView.image = UIImage()
        self.firstWordLabel.text = nil
        self.transform = .identity
    }
    
    
    // MARK: - Functions 
    /// 뷰 체계 설정
    private func configureHierarchy() {
        self.noteImageView.translatesAutoresizingMaskIntoConstraints = false
        self.firstWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.noteImageView)
        self.contentView.addSubview(self.firstWordLabel)
    }
    
    /// 오토레이아웃 설정
    private func configureConstraints() {
        self.configureNoteImageViewConstraints()
        self.configureFirstWordLabelConstraints()
    }
    
    /// 쪽지 이미지뷰 오토레이아웃
    private func configureNoteImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.noteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.noteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.noteImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.noteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// 단어 라벨 오토레이아웃
    private func configureFirstWordLabelConstraints() {
        NSLayoutConstraint.activate([
            self.firstWordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.firstWordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
