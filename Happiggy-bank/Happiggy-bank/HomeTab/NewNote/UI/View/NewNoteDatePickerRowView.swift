//
//  NewNoteDatePickerRowView.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새로운 쪽지 추가 시 사용하는 날짜 피커의 각 행을 나타내는 뷰
class NewNoteDatePickerRowView: UIView {
    
    // MARK: - @IBOutlet
    
    /// 이미지 뷰와 날짜 라벨을 담고 있는 스택 뷰 DatePickerRowView.xib 과 연결
    @IBOutlet var contentView: UIStackView!
    
    /// 해당 날짜에 쪽지를 썼는지 나타낼 이미지 뷰
    @IBOutlet var colorImageView: UIImageView!
    
    /// 날짜 라벨
    @IBOutlet var dateLabel: UILabel!
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    
    // MARK: - Functions
    
    /// contentview 를 하위 뷰로 추가하고, frame, autoresizingMask 설정
    private func commonInit() {
        Bundle.main.loadNibNamed(NewNoteDatePickerRowView.name, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
