//
//  NoteView.swift
//  Happiggy-bank
//
//  Created by Eunbin Kwon on 2022/03/22.
//

import UIKit

import Then

/// 저금통에 담길 노트 노드
final class NoteView: UIView {
    
    // MARK: - Properties
        
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        .ellipse
    }
    
    /// 노트 노드 이미지
    private var imageView: UIImageView!
    
    
    // MARK: - Inits
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, color: NoteColor) {
        self.init(frame: frame)
        
        self.layer.zPosition = Metric.randomZpostion
        self.configureImageView(withColor: color)
    }
    
    
    // MARK: - Functions
    
    /// 쪽지 색깔에 맞게 이미지 뷰를 생성하고 서브 뷰로 추가
    private func configureImageView(withColor color: NoteColor) {
        self.imageView = UIImageView(image: .note(color: color)).then {
            $0.frame = self.bounds
            $0.contentMode = .scaleAspectFit
            $0.transform = self.transform.rotated(by: Metric.randomDegree)
        }
        self.addSubview(self.imageView)
    }
}
