//
//  CapsuleButton.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/20.
//

import UIKit

/// 캡슐 모양 테두리를 갖는 버튼
final class CapsuleButton: UIButton {
    
    // MARK: - @IBOulet
    
    /// 제목 라벨의 상위 뷰로 캡슐 모양 테두리를 나타낼 뷰
    @IBOutlet weak var contentView: UIView!
    
    /// 제목 라벨
    @IBOutlet weak var textLabel: UILabel!
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    
    // MARK: - Functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeCapsuleBorder()
    }
    
    /// init 시 해야하는 공통 작업
    private func commonInit() {
        self.loadAndConfigureXib()
        self.makeCapsuleBorder()
    }
    
    /// xib 파일 로딩하고 관련 설정
    private func loadAndConfigureXib() {
        Bundle.main.loadNibNamed(CapsuleButton.name, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /// 캡슐 모양 테두리 설정
    private func makeCapsuleBorder() {
        self.contentView.layer.cornerRadius = self.frame.height / 2
        self.contentView.layer.borderWidth = Metric.borderWidth
        self.contentView.layer.borderColor = UIColor.customSecondaryLabel.cgColor
    }
}
