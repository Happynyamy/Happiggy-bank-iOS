//
//  NoteProgressLabel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

/// 쪽지 개수 보여주는 라벨
final class NoteProgressLabel: UIView {
    
    /// 쪽지 아이콘
    var noteIcon: UIImageView!
    
    /// 쪽지 개수 라벨
    var noteTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 126, height: 48)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 23
        configureNoteIcon()
        configureNoteLabel()
        configureConstraintsOfSubview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 쪽지 아이콘 설정
    private func configureNoteIcon() {
        self.noteIcon = UIImageView()
        self.noteIcon.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        self.noteIcon.image = UIImage(systemName: "note")
        self.addSubview(noteIcon)
    }
    
    /// 쪽지 개수 라벨 설정
    private func configureNoteLabel() {
        self.noteTextLabel = UILabel()
        self.noteTextLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 16)
        self.noteTextLabel.text = "50 / 365"
        self.noteTextLabel.font = .systemFont(ofSize: 15)
        self.addSubview(noteTextLabel)
    }
    
    /// 하위 뷰 constraints 설정
    private func configureConstraintsOfSubview() {
        self.noteIcon.translatesAutoresizingMaskIntoConstraints = false
        self.noteTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.noteIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.noteIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            self.noteTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.noteTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        ])
    }
}
