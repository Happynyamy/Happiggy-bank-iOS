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
    
    // MARK: Properties
    
    /// 노트 노드 이미지
    var imageView: UIImageView = UIImageView().then {
        $0.image = UIImage.note(color: .default)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 노트 노드 레이어
    var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.allowsEdgeAntialiasing = true
        return shapeLayer
    }()
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }

    override var collisionBoundingPath: UIBezierPath {
        return circularPath()
    }

    
    // MARK: Override Functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(self.imageView)

        layer.addSublayer(shapeLayer)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.path = circularPath(lineWidth: 0, center: center).cgPath
    }

    
    // MARK: Functions
    
    // TODO: 이미지에 맞게 path 설정
    /// 원형 path 설정
    private func circularPath(
        lineWidth: CGFloat = 0,
        center: CGPoint = .zero
    ) -> UIBezierPath {
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        
        return UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
    }
}
