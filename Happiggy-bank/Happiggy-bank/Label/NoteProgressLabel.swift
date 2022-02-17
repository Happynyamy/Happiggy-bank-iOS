//
//  NoteProgressLabel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

class NoteProgressLabel: UIView {
    
    var noteIcon: UIImageView!
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
    
    private func configureNoteIcon() {
        self.noteIcon = UIImageView()
        self.noteIcon.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        self.noteIcon.image = UIImage(systemName: "note")
        self.addSubview(noteIcon)
    }
    
    private func configureNoteLabel() {
        self.noteTextLabel = UILabel()
        self.noteTextLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 16)
        self.noteTextLabel.text = "50 / 365"
        self.noteTextLabel.font = .systemFont(ofSize: 15)
        self.addSubview(noteTextLabel)
    }
    
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
