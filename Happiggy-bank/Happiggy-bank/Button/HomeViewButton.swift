//
//  HomeViewButton.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/19.
//

import UIKit

class HomeViewButton: UIButton {
    
    private var buttonFrame: CGRect = CGRect(
        x: 0,
        y: 0,
        width: Metric.buttonWidth,
        height: Metric.buttonHeight
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(imageName: String) {
        super.init(frame: buttonFrame)
        
        let buttonImage = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        
        self.setImage(buttonImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
