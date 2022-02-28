//
//  NotesViewCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/26.
//

import UIKit

import Then

/// NotesView 에서 사용하는 아이템 셀로 각 쪽지의 날짜를 나타냄
class NotesViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// 쪽지 이미지
    var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    /// 쪽지 작성 날짜 라벨
    var dateLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureViewHierarchy()
        self.configureDateLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Functions
    
    /// 뷰 체계 설정
    private func configureViewHierarchy() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.dateLabel)
    }
    
    /// 날짜 라벨 오토 레이아웃 설정
    private func configureDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
